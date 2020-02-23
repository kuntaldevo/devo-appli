#!/bin/sh

NAME=paxata-server

CMDLIST="start stop status restart"
usage="\nUsage is: $CMDLIST\n\tExample: ./$NAME.sh start"

SERVER_HOME="$( cd "$(dirname "$0")" ; pwd -P )"
SERVER_LOGDIR="$SERVER_HOME/logs"
SERVER_LOGFILE=stdout.log
SERVER_ACTUAL_LOGFILE=frontend.log
SERVER_LIB="$SERVER_HOME/lib"
SERVER_JAR="$SERVER_HOME/paxata-server.jar"
SERVER_CONFIG="$SERVER_HOME/config"
SERVER_PIDFILE="$SERVER_LOGDIR/paxata-server.pid"
SERVER_CONFIG_FILES="$SERVER_CONFIG/px-defaults.properties $SERVER_CONFIG/px.properties"

function mergePropertyFile() {
  if [ -f "$1" ]; then
    printf "\n#\n# Merged property file $1\n#\n" >> "$SERVER_CONFIG/px.properties"
    cat "$1" >> "$SERVER_CONFIG/px.properties"
    mv "$1" "$1.deprecated"
  fi
}

function getPropertyValue () {
  cat $SERVER_CONFIG_FILES | grep -v '#' | grep "$1=" | tail -n 1 | cut -d = -f 2 -
}

function setJavaXXArg () {
	XX=""
	keys=`cat $SERVER_CONFIG_FILES | grep -v '#' | grep "px.xx." |awk -F '=' '{print $1}' | sort -u | uniq`

	for key in $keys; do
		arg=`echo $key | awk -F 'px.xx.' '{print "-XX:"$2}'`
		local value=$(getPropertyValue $key)

		if [ -z $value ]; then
			XX+="$arg "
		else
			XX+="$arg=$value "
		fi
	done
}

function start() {
  printf "%-50s" "Starting $NAME..."
  ps -ef | grep -v grep | grep D$NAME > /dev/null 2>&1

  if [ $? == 0 ]; then
      echo -e "\n\t$NAME appears to already be running, do you have a zombie process?"
      exit 1
  fi

  mergePropertyFile "$SERVER_CONFIG/database.properties"
  mergePropertyFile "$SERVER_CONFIG/jetty.properties"
  mergePropertyFile "$SERVER_CONFIG/hornetq.properties"
  mergePropertyFile "$SERVER_CONFIG/distributions.properties"
  mergePropertyFile "$SERVER_CONFIG/filesystem.properties"
  mergePropertyFile "$SERVER_CONFIG/manager.properties"

  SERVER_REDIRECT=$( getPropertyValue px.port.redirect )
  SERVER_USESSL=$( getPropertyValue px.use.ssl )
  SERVER_NONSSLPORT=$( getPropertyValue px.port)
  SERVER_SSLPORT=$( getPropertyValue px.ssl.port )

  if [ -f ${SERVER_CONFIG}/test_setup.sh ]
    then
        source ${SERVER_CONFIG}/test_setup.sh
  fi

  today=$(date +%Y%m%dT%H%M%S%3N)
  HEAP_DUMP="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${SERVER_LOGDIR}/heapdump_$$_$today.hprof"
  GC_LOG="-Xloggc:${SERVER_LOGDIR}/gc_$today.log -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=15 -XX:GCLogFileSize=48M -XX:+PrintFlagsFinal -XX:+PrintJNIGCStalls -XX:+PrintTLAB -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:+PrintGCDateStamps -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationConcurrentTime -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy -XX:+PrintHeapAtGC -XX:+PrintGCCause -XX:+PrintReferenceGC"  REFLECTION_OPTS="-Dsun.reflect.inflationThreshold=0"

  DEBUG_OPTS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"
  LOG4J_ARGS="-DLog4jContextSelector=org.apache.logging.log4j.core.async.AsyncLoggerContextSelector -Dlog4j.configuration=file:${SERVER_CONFIG}/log4j.properties"
  ENCODING=$( getPropertyValue px.default.encoding)
  setJavaXXArg

  if [ ! -z $ENCODING ]; then
    ENCODING_ARGS="-Dsun.jnu.encoding=$ENCODING -Dfile.encoding=$ENCODING"
  else
    ENCODING_ARGS=""
  fi

  netstat --version > /dev/null 2>&1

  if [ $? == 5 ]
  then
      if [[ "$SERVER_REDIRECT" = "true" && "$SERVER_USESSL" == "true" ]]
      then
        SERVER_PORT="$SERVER_NONSSLPORT or $SERVER_SSLPORT"
        netstat -lnt |grep -e ":$SERVER_NONSSLPORT " -e ":$SERVER_SSLPORT " &>/dev/null 2>&1
      elif [[ "$SERVER_REDIRECT" = "false" && "$SERVER_USESSL" == "true" ]]
      then
        SERVER_PORT="$SERVER_SSLPORT"
        netstat -lnt |grep ":$SERVER_SSLPORT "  &>/dev/null 2>&1
      elif [[ "$SERVER_REDIRECT" = "false" && "$SERVER_USESSL" == "false" ]]
      then
        SERVER_PORT="$SERVER_NONSSLPORT"
        netstat -lnt |grep ":$SERVER_NONSSLPORT "  &>/dev/null 2>&1
      else
        echo -e "\n\tYou cannot redirect a port unless you're using SSL"
        echo -e "\n\tPlease fix the config in $SERVER_CONFIG/jetty.properties"
        exit 1
      fi
  else
      false
  fi

  STATE=$?
  if [ $STATE == 1 ]
  then
      mkdir -p $SERVER_LOGDIR
      cd $SERVER_HOME
      exec java -D$NAME $XX $GC_LOG $HEAP_DUMP $REFLECTION_OPTS $LOG4J_ARGS $ENCODING_ARGS -jar $SERVER_JAR $SERVER_ARGS > $SERVER_LOGDIR/$SERVER_LOGFILE 2>&1 &

      SERVER_PID=$!
      sleep 1

      if [ -z "`ps axf | grep ${SERVER_PID} | grep -v grep`" ]; then
        printf "%s\n" "Failed to start $NAME"
        tail -n 5 $SERVER_LOGDIR/stdout.log
      else
        echo $SERVER_PID >$SERVER_PIDFILE

        echo -e "\nProcess is running in the background as PID: $SERVER_PID"
        echo "Output file is: $SERVER_LOGDIR/$SERVER_ACTUAL_LOGFILE"
        printf "%s\n" "Ok"
      fi
  else
      echo -e "\n\tPort $SERVER_PORT already listening, do you have a zombie process?"
  fi
}

function stop(){
    printf "%-50s" "Stopping $NAME"
  if [ -f $SERVER_PIDFILE ]
  then
      PID=`cat $SERVER_PIDFILE`
      echo
      (hash jstack 2>/dev/null || {
        echo >&3 "Not taking jstack of existing process. Please set up jstack to gain this functionality";
        false;
        }) && {
        filename=$SERVER_LOGDIR/$NAME-`date '+%Y-%m-%d-%H-%M-%S'`-jstack.txt
        echo "Dumping jstack of existing process to" $filename
        jstack -l $PID > $filename
        }
        sleep 3
        kill -HUP $PID
        echo "Waiting for process to terminate..."
        sleep 1
        while ps -p $PID > /dev/null; do echo -n "."; sleep 1; done
        printf "%s\n" "Ok"
        rm -f $SERVER_PIDFILE
    else
        printf "%s\n" "pidfile not found"
    fi

    return 0
}

function status(){
  printf "%-50s" "Checking $NAME..."
  if [ -f $SERVER_PIDFILE ]; then
      PID=`cat $SERVER_PIDFILE`
      if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
        printf "%s\n" "Process dead but pidfile exists"
      else
        echo "Running"
      fi
    else
      printf "%s\n" "Service not running"
    fi
}

function restart(){
  stop
  start
}

for i in $CMDLIST
do
  if [ "$1" == "$i" ]
  then
      VALIDCOMMAND="true"
  fi
done

if [ "$VALIDCOMMAND" == "true" ]
then
  $1
else
  echo -e "$usage"
  exit 1
fi
