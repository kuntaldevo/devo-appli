#!/bin/bash

NAME=paxata-pipeline
CMDLIST="start stop status restart"

function usage {
	echo -e "\nUsage: $(basename $0) [$(echo $CMDLIST | tr ' ' '|')]"
	exit 1
}

PIPELINE_HOME="$( cd "$(dirname "$0")" ; pwd -P )"
PIPELINE_LOGDIR="$PIPELINE_HOME/logs"
PIPELINE_LIB="$PIPELINE_HOME/lib"
PIPELINE_CONFIG="$PIPELINE_HOME/config"
PIPELINE_CONFIG_FILES="$PIPELINE_CONFIG/paxata.properties"
PIPELINE_LOGFILE="pipeline.log"
PIPELINE_PIDFILE=${PIPELINE_LOGDIR}/${NAME}.pid

function fail_message {
	echo -e "[\e[0;31m FAILED \e[0m]\n\t$@"
}

function fail_with {
	fail_message $@
	exit 1
}

function property {
	awk "/^$2/ {match(\$0,/[^=]+=(.*)/,arr); print arr[1]}" $1
}

function getPropertyValue () {
	cat ${PIPELINE_CONFIG_FILES} | grep -v '#' | grep "$1=" | tail -n 1 | cut -d = -f 2 -
}

function setJavaXXArg () {
	XX=""
	keys=`cat ${PIPELINE_CONFIG_FILES} | grep -v '#' | grep "px.xx." |awk -F '=' '{print $1}' | sort -u | uniq`

	for key in $keys; do
		arg=`echo $key | awk -F 'px.xx.' '{print "-XX:"$2}'`
		local value=$(getPropertyValue $key)

		# Don't set Xmx/MaxHeapSize twice (in DRIVER_JAVA_OPTIONS and --driver-memory "$MAX_HEAP_SIZE")
		if [ $key != "px.xx.MaxHeapSize" ]; then
			if [ -z $value ]; then
				XX+="$arg "
			else
				XX+="$arg=$value "
			fi
		fi
	done
}

function start() {
	printf "%-50s" "Starting $NAME..."
	ps axf | grep -v grep | grep -- -D${NAME} > /dev/null 2>&1

	if [ $? -eq 0 ]; then
		fail_with "$NAME appears to already be running, do you have a zombie process?"
	fi

	PIPELINE_PORT=`property ${PIPELINE_CONFIG}/http.properties "port"`
	RETRY=1

	SPARK_HOME=`property ${PIPELINE_CONFIG}/spark.properties "spark.home"`
	SPARK_CONF_HOME=${SPARK_HOME}/conf
	SPARK_BIN_HOME=${SPARK_HOME}/bin
	SPARK_LOG_HOME=${SPARK_HOME}/logs
	SPARK_JARS=$(find $SPARK_HOME/{lib,jars} -type f -name '*.jar' 2>/dev/null | tr '\n' ':')

	LOG4J_CONFIG="$PIPELINE_CONFIG/log4j.properties"

	# Make sure the log directory exists
	mkdir -p ${PIPELINE_LOGDIR}

	ss -nlt |grep ":$PIPELINE_PORT " &>/dev/null 2>&1

	if [ $? -eq 1 ]; then
		MASTER_URL=`property ${PIPELINE_CONFIG}/spark.properties "master.url"`

		if [[ ${MASTER_URL} != "spark://"* ]] && [[ ${MASTER_URL} != "yarn-client" ]] && [[ ${MASTER_URL} != "yarn" ]]; then
			fail_with "$MASTER_URL is not currently a supported configuration. Please contact support with questions"
		elif [ ${MASTER_URL} != "yarn-client" ] && [ ${MASTER_URL} != "yarn" ]; then
			MASTER_HOSTPORT=`echo ${MASTER_URL} | tr -s '/' | cut -d / -f 2 -`
			MASTER_HOST=`echo ${MASTER_HOSTPORT} | cut -d : -f 1 -`
			MASTER_PORT=`echo ${MASTER_HOSTPORT} | cut -d : -f 2 -`

			which dig

			if [ "$?" -ne 0 ]; then
				echo "Please install bind-utils rpm. Exit."
				exit 1
			fi

			ADDRS=$(dig +short ${MASTER_HOST})

			if [ -z "$ADDRS" ]; then
				ADDRS_STATE=FAILURE
			else
				ADDRS_STATE=SUCCESS
			fi

			ADDRS2=$(cat /etc/hosts |grep -q ${MASTER_HOST})

			if [ $? = 0 ]; then
				ADDRS_ALT_STATE=SUCCESS
			else
				ADDRS_ALT_STATE=FAILURE
			fi

			if [[ "$ADDRS_STATE" == "SUCCESS" ]] || [[ "$ADDRS_ALT_STATE" == "SUCCESS" ]]; then
				timeout 1 bash -c "cat < /dev/null > /dev/tcp/$MASTER_HOST/$MASTER_PORT" >/dev/null 2>&1
				STATE=$?

				while [[ (${STATE} -eq 1) && (${RETRY} -le 5) ]]; do
					echo -e "\n\tMaster isn't responding on hostname $MASTER_HOST with port $MASTER_PORT, waiting and retrying"
					sleep 5
					(( RETRY++ ))
					timeout 1 bash -c "cat < /dev/null > /dev/tcp/$MASTER_HOST/$MASTER_PORT" >/dev/null 2>&1
					STATE=$?
				done

				if [ ${STATE} -eq 124 ]; then
					fail_with "You may have a firewall blocking your access to the Spark Master: $MASTER_HOST with port $MASTER_PORT"
				fi

				if [ ${RETRY} -gt 5 ]; then
					fail_with "Unable to reach spark master at $MASTER_HOST with port $MASTER_PORT, exiting"
				fi
			else
				fail_with "The Spark Master: $MASTER_HOST could not be resolved by DNS nor in /etc/hosts"
			fi
		fi

		CLASSPATH=${PIPELINE_CONFIG}:${SPARK_JARS}:${PIPELINE_LIB}/*
		today=$(date +%Y%m%dT%H%M%S%3N)

		PIPELINE_HEAP_DUMP="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${PIPELINE_LOGDIR}/heapdump_$$_${today}.hprof"
		PIPELINE_GC_LOGS="-Xloggc:${PIPELINE_LOGDIR}/gc_${today}.log -XX:LogFile=${PIPELINE_LOGDIR}/safepoint_${today}.log"

		SPARK_HEAP_DUMP="-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${SPARK_LOG_HOME}/heapdump_$$_${today}.hprof"
		SPARK_GC_LOGS="-Xloggc:${SPARK_LOG_HOME}/gc_${today}.log -XX:LogFile=${SPARK_LOG_HOME}/safepoint_${today}.log"

		GC_OPTS="-XX:+UnlockDiagnosticVMOptions -XX:+LogVMOutput -XX:+PrintFlagsFinal -XX:+PrintJNIGCStalls -XX:+PrintTLAB -XX:+PrintGCDateStamps -XX:+PrintGCDetails -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=15 -XX:GCLogFileSize=48M -XX:+PrintTenuringDistribution -XX:+PrintGCApplicationConcurrentTime -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy -XX:+PrintHeapAtGC -XX:+PrintGCCause -XX:+PrintReferenceGC -XX:+PrintSafepointStatistics -XX:PrintSafepointStatisticsCount=1"

		setJavaXXArg
		MAX_HEAP_SIZE=`property ${PIPELINE_CONFIG}/paxata.properties "px.xx.MaxHeapSize"`
		MIN_HEAP_SIZE=`property ${PIPELINE_CONFIG}/paxata.properties "px.xx.InitialHeapSize"`

		SPARK_STANDALONE_OPTS=`property ${PIPELINE_CONFIG}/spark.properties "spark-standalone.extra.args"`
		SPARK_STANDALONE_OPTS="$SPARK_STANDALONE_OPTS $GC_OPTS $SPARK_GC_LOGS $SPARK_HEAP_DUMP"

		NUM_EXECUTORS=`property ${PIPELINE_CONFIG}/spark.properties "yarn.num.executors"`
		EXECUTOR_MEMORY=`property ${PIPELINE_CONFIG}/paxata.properties "px.executor.memory"`
		EXECUTOR_CORES=`property ${PIPELINE_CONFIG}/spark.properties "yarn.executor.cores"`

		SPARK_YARN_JAR=`property ${PIPELINE_CONFIG}/spark.properties "spark.yarn.jar"`
		SPARK_YARN_QUEUE=`property ${PIPELINE_CONFIG}/spark.properties "spark.yarn.queue"`
		SPARK_YARN_JARS=`property ${PIPELINE_CONFIG}/spark.properties "spark.yarn.jars"`

		PIPELINE_CACHE=`property ${PIPELINE_CONFIG}/paxata.properties "px.rootdir"`

		DRIVER_JAVA_OPTIONS="-D${NAME} ${XX} -Dlog4j.configuration=${LOG4J_CONFIG} -Dspark.local.dir=${PIPELINE_CACHE} -Dspark.cleaner.referenceTracking.blocking=false -Dspark.cleaner.periodicGC.interval=120min"

		if [ ! -z "$SPARK_YARN_JAR" ]; then
			DRIVER_JAVA_OPTIONS="$DRIVER_JAVA_OPTIONS -Dspark.yarn.jar=$SPARK_YARN_JAR"
		elif [ ! -z "$SPARK_YARN_JARS" ]; then
			DRIVER_JAVA_OPTIONS="$DRIVER_JAVA_OPTIONS -Dspark.yarn.jars=$SPARK_YARN_JARS"
		fi

		cd ${PIPELINE_HOME}

		if [ ${MASTER_URL} != "yarn-client" ] && [ ${MASTER_URL} != "yarn" ]; then
			DRIVER_JAVA_OPTIONS="-XX:InitialHeapSize=$MIN_HEAP_SIZE -XX:MaxHeapSize=$MAX_HEAP_SIZE $DRIVER_JAVA_OPTIONS"

			exec java ${PIPELINE_HEAP_DUMP} ${GC_OPTS} ${PIPELINE_GC_LOGS} \
				${DRIVER_JAVA_OPTIONS} \
				-Dspark.executor.memory=${EXECUTOR_MEMORY} \
				-Dspark.executor.extraJavaOptions="${SPARK_STANDALONE_OPTS}" \
				-classpath ${CLASSPATH} \
				com.paxata.spark.Main >> ${PIPELINE_LOGDIR}/${PIPELINE_LOGFILE} 2>&1 &
		else
			export HADOOP_CONF_DIR=`property ${PIPELINE_CONFIG}/spark.properties "hadoop.conf"`

			ADDL_SPARK_SUBMIT_ARGS=`property ${PIPELINE_CONFIG}/spark.properties "spark-submit.extra.args"`
			ADDL_SPARK_SUBMIT_ARGS="--conf \"$ADDL_SPARK_SUBMIT_ARGS $SPARK_GC_LOGS $GC_OPTS $SPARK_HEAP_DUMP\""

			SPARK_SUBMIT=${SPARK_BIN_HOME}/spark-submit

			if [ -f ${SPARK_BIN_HOME}/spark2-submit ]; then
				SPARK_SUBMIT=${SPARK_BIN_HOME}/spark2-submit
			fi

			exec ${SPARK_SUBMIT} ${ADDL_SPARK_SUBMIT_ARGS} \
				--jars "$PIPELINE_LIB/pipeline-rdd.jar" \
				--driver-memory "$MAX_HEAP_SIZE" \
				--queue "$SPARK_YARN_QUEUE" \
				--deploy-mode "client" \
				--master "$MASTER_URL" \
				--driver-java-options "$DRIVER_JAVA_OPTIONS" \
				--conf "spark.executor.instances=$NUM_EXECUTORS" \
				--conf "spark.dynamicAllocation.enabled=false" \
				--num-executors "$NUM_EXECUTORS" \
				--executor-cores="$EXECUTOR_CORES" \
				--executor-memory "$EXECUTOR_MEMORY" \
				--driver-class-path "$CLASSPATH" \
				--class com.paxata.spark.Main \
				${PIPELINE_LIB}/pipeline.jar >> ${PIPELINE_LOGDIR}/${PIPELINE_LOGFILE} 2>&1 &
		fi

		PIPELINE_PID=$!
		sleep 1

		if [ -z "`ps axf | grep ${PIPELINE_PID} | grep -v grep`" ]; then
			fail_message "Unable to start $NAME"
			tail -n 5 ${PIPELINE_LOGDIR}/${PIPELINE_LOGFILE}
		else
			echo -e "[\e[0;32m OK \e[0m]"
			echo ${PIPELINE_PID} >${PIPELINE_PIDFILE}
			echo -e "\nProcess is running in the background as PID: $PIPELINE_PID"
			echo "Output file is: $PIPELINE_LOGDIR/$PIPELINE_LOGFILE"
		fi
	else
		fail_with "Port $PIPELINE_PORT is already listening, do you have a zombie process?"
	fi
}

function stop {
	printf "%-50s" "Stopping $NAME"

	if [ -f ${PIPELINE_PIDFILE} ]; then
		PID=`cat ${PIPELINE_PIDFILE}`
		echo
		(hash jstack 2>/dev/null || {
			echo >&2 "Not taking jstack of existing process. Please set up jstack to gain this functionality";
			false;
		 }) && {
			filename=${PIPELINE_LOGDIR}/${NAME}-`date '+%Y-%m-%d-%H-%M-%S'`-jstack.txt
			echo "Dumping jstack of existing process to" ${filename}
			jstack -l ${PID} > ${filename}
		}

		sleep 3
		kill -HUP ${PID}
		echo "Waiting for process to terminate..."
		sleep 1

		while ps -p ${PID} > /dev/null; do
			echo -n "."
			sleep 1
		done

		echo -e "[\e[0;32m OK \e[0m]"

		rm -f ${PIPELINE_PIDFILE}
	else
		fail_message "Pidfile not found"
	fi

	return 0
}

function status {
	if [ -f ${PIPELINE_PIDFILE} ]; then
		PID=`cat ${PIPELINE_PIDFILE}`

		if [ -z "`ps axf | grep ${PID} | grep -v grep`" ]; then
			fail_message "Process dead but pidfile exists"
		else
			echo -e "$NAME (pid  $PID) is running..."
		fi
	else
		echo -e "\n$NAME is stopped"
	fi
}

function restart {
	stop
	start
}

for i in ${CMDLIST}; do
	if [ "$1" == "$i" ]; then
		$1
		exit $?
	fi
done

usage
