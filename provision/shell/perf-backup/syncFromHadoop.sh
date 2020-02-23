#!/bin/bash

export PATH=/usr/lib64/qt-3.3/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/root/bin:$PATH
export START=`date +%s`

export ROOTDIR=/usr/local/backup
export FILES='currentBackup removedRowOne sortedBackup currentHadoop sortedHadoop backupDiff HDFSSyncOutput HDFSSyncErrorOutput'
export HADOOP_CLIENT_OPTS="-XX:-UseGCOverheadLimit -Xmx4096m"

readonly PROGNAME=$(basename "$0")
readonly LOCKFILE_DIR=/tmp
readonly LOCK_FD=200
readonly LOG_FILE="/var/log/hdfs-duplicity.log"

lock() {
    local prefix=$1
    local fd=${2:-$LOCK_FD}
    local lock_file=$LOCKFILE_DIR/$prefix.lock

    # create lock file
    eval "exec $fd>$lock_file"

    # seize the lock
    flock -n $fd \
        && return 0 \
        || return 1
}

crash() {
    local error_str="$@"

    echo $error_str
    exit 1
}

rotateOldFiles() {
  for i in `echo $FILES`
  do
    rm -f $ROOTDIR/${i}.old
  done

  for i in `echo $FILES`
  do
    mv $ROOTDIR/${i} $ROOTDIR/${i}.old
  done
}

createFileLists() {
  echo "Create list of sorted files already backed up"
  find $ROOTDIR/prod-e1/ |awk -F "prod-e1" '{print $2}' >$ROOTDIR/currentBackup; sed '1d' $ROOTDIR/currentBackup > $ROOTDIR/removedRowOne; cat $ROOTDIR/removedRowOne |sort -r >$ROOTDIR/sortedBackup

  echo "Create list of sorted files currently in hadoop"
  hadoop dfs -ls -R /user/datalibrary/prod-e1/ |awk -F "prod-e1" '{print $2}' >$ROOTDIR/currentHadoop; cat $ROOTDIR/currentHadoop |sort -r >$ROOTDIR/sortedHadoop

  echo "Diff the files currently in the backup with those currently in Hadoop"
  diff $ROOTDIR/sortedHadoop $ROOTDIR/sortedBackup |grep paxata | sed 's/> //' | sed 's/< //' >$ROOTDIR/backupDiff
}

removeOldFiles() {
  echo "Remove files from current backup that are no longer in hadoop"
  for PASSED in `cat $ROOTDIR/backupDiff`
  do
    if [[ -d $ROOTDIR/prod-e1/$PASSED ]]; then
        echo "$PASSED is a directory"
        rmdir $ROOTDIR/prod-e1/$PASSED
    elif [[ -f $ROOTDIR/prod-e1/$PASSED ]]; then
        echo "$PASSED is a file"
        rm -f $ROOTDIR/prod-e1/$PASSED
    else
        echo "notADirectoryOrFile $PASSED"
    fi
  done
}

syncFromHadoop() {
  echo "Resync data from Hadoop"
  #DLEV - Remove 4-23-19 - You cannot sync ALL of hadoop, it will java lang oom and use all CPU forever
  #date +%s; hadoop dfs -copyToLocal /user/datalibrary/prod-e1 $ROOTDIR/ >$ROOTDIR/HDFSSyncOutput 2>$ROOTDIR/HDFSSyncErrorOutput; date +%s
  for i in `hdfs dfs -ls /user/datalibrary/prod-e1/paxata/ |grep -v 'prod-e1/paxata/library' |grep -v hive |awk -F ' ' '{print $8}' |grep prod-e1`
  do
     date +%s; hadoop dfs -copyToLocal $i $ROOTDIR/prod-e1/paxata/ >>$ROOTDIR/HDFSSyncOutput 2>>$ROOTDIR/HDFSSyncErrorOutput; date +%s
  done
  for i in `hdfs dfs -ls /user/datalibrary/prod-e1/paxata/library |awk -F ' ' '{print $8}' |grep prod-e1`
  do
     date +%s; hadoop dfs -copyToLocal $i $ROOTDIR/prod-e1/paxata/library/ >>$ROOTDIR/HDFSSyncOutput 2>>$ROOTDIR/HDFSSyncErrorOutput; date +%s
  done

  echo "Check that local backup now matches"
  #find $ROOTDIR/prod-e1/ |awk -F "prod-e1" '{print $2}' >$ROOTDIR/currentBackup; sed '1d' $ROOTDIR/currentBackup > $ROOTDIR/removedRowOne; cat $ROOTDIR/removedRowOne |sort -r >$ROOTDIR/sortedBackup
  #diff $ROOTDIR/sortedHadoop $ROOTDIR/sortedBackup
  export FINISH=`date +%s`
  echo "Time taken in seconds is `expr $FINISH - $START`"
}

main() {
  lock $PROGNAME \
        || crash "Only one instance of $PROGNAME can run at one time."

  rotateOldFiles
  createFileLists
  removeOldFiles
  syncFromHadoop

#  echo -e "\n\nSyncing to S3 at $(date)\n"
#  date +%s; duply hdfs backup --s3-use-multiprocessing | tee -a ${LOG_FILE}; date +%s
  rm /tmp/syncFromHadoop.sh.lock
}

main
