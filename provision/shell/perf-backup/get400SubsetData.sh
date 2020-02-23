#!/bin/bash

function usage()
{
	echo
	echo "$0 mongoserver [--clean] [--archive]"
	echo -e "\tmongoserver is the current production server that is doing backups."
	echo -e "\t--clean will purge the backup directory for a fresh backup. If this option is not provided, the previous backups are kept."
	echo -e "\t--archive will create a tar.gz file of the hdfs backup.\n\tExample: prod-e2-mongo2\n"
	exit 1
}

function cleanUp()
{
	# Clean up previous backup
	echo "Cleaning up previous backups" | logger -t ${mongoserver}_hdfs_library_files
	# Don't want to delete DESTDIR because we are keeping this script there.
	rm -rf ${DESTDIR}/${mongoserver} ${DESTDIR}/hdfs-validation-files*.tar
	mkdir -p ${DESTDIR}/${mongoserver}/${thedate}
}

function runBackup()
{
	today=$(date +%m-%d)
	cd ${DESTDIR}

	# Grab the metadata files
	aws --profile datavalidation s3 cp ${S3mongometa}/prod-library-files-${today}.txt ${DESTDIR}/${mongoserver}/${thedate}/
	aws --profile datavalidation s3 cp ${S3mongometa}/prod-project-lists-${today}.txt ${DESTDIR}/${mongoserver}/${thedate}/
	aws --profile datavalidation s3 cp ${S3mongometa}/7day-latest-version-${today}.txt ${DESTDIR}/${mongoserver}/${thedate}/
	#aws --profile datavalidation s3 cp ${S3mongometa}/prod-7day-recent-files-${today}.txt ${DESTDIR}/${mongoserver}/${thedate}/
	aws --profile datavalidation s3 cp ${S3mongometa}/preview-upload-paths-${today}.txt ${DESTDIR}/${mongoserver}/${thedate}/

	if [ ! -f ${DESTDIR}/${mongoserver}/${thedate}/prod-library-files-$(date +%m-%d).txt ]
	then
		echo "ERROR: Unable to find prod-library-files-$(date +%m-%d).txt" | logger -t ${mongoserver}_hdfs_library_files
		exit 1
	fi

	echo "Copy hdfs files into ${DESTDIR}" | logger -t ${mongoserver}_hdfs_library_files
	sort ${DESTDIR}/${mongoserver}/${thedate}/prod-library-files-$(date +%m-%d).txt | uniq |
	while read f j
	do
		# skip blank lines
		[ -z "${f}" ] && continue
		echo "mkdir ${f%/*}" | logger -t mkdir_library_debug
		mkdir -p ${DESTDIR}/${mongoserver}/${thedate}/${f%/*}
		hdfs dfs -copyToLocal ${hdfsroot}/${f} ${DESTDIR}/${mongoserver}/${thedate}/${f%/*}
	done

	echo "Copy the latest version of data files that were created in the last 7 days" | logger -t ${mongoserver}_hdfs_library_files
	sort ${DESTDIR}/${mongoserver}/${thedate}/7day-latest-version-${today}.txt | uniq |
	while read f1 j
	do
		# skip blank lines
		[ -z "${f1}" ] && continue
		echo "mkdir ${f1%/*}" | logger -t mkdir_7day_debug
		mkdir -p ${DESTDIR}/${mongoserver}/${thedate}/${f1%/*}
		hdfs dfs -copyToLocal ${hdfsroot}/${f1} ${DESTDIR}/${mongoserver}/${thedate}/${f1%/*}
	done

	echo "Copy the preview upload data over the last 7 days" | logger -t ${mongoserver}_hdfs_library_files
	sort ${DESTDIR}/${mongoserver}/${thedate}/preview-upload-paths-${today}.txt | uniq |
	while read p1 j
	do
		[ -z "${p1}" ] && continue
		echo "mkdir ${p1%/*}" | logger -t mkdir_preview_debug
		mkdir -p ${DESTDIR}/${mongoserver}/${thedate}/${p1%/*}
		hdfs dfs -copyToLocal ${hdfsroot}/${p1} ${DESTDIR}/${mongoserver}/${thedate}/${p1%/*}
	done

	if [[ ${archivearg} -eq 1 ]]
	then
		# Archive the files
		echo "Creating archive of hdfs files" | logger -t ${mongoserver}_hdfs_library_files
		cd ${DESTDIR}
		tar cf hdfs-validation-files-$(date +%m-%d).tar ${mongoserver}/
	fi

	# Copy files to S3
	echo "Copying hdfs files to ${S3validation}" | logger -t ${mongoserver}_hdfs_library_files
	aws --profile datavalidation --quiet --delete s3 sync ${mongoserver}/${thedate}/ ${S3validation}
}

if [ -z "$1" ]
then
	usage
fi

mongoserver=`echo $1 | awk '{print tolower($0)}'`

if [ -z "${mongoserver}" ]
then
	echo "ERROR: mongoserver option was empty. Exiting."
	exit 99
fi

# check to see if any other args are present
shift
for arg in $@
do
	if [ "${arg}" = "--clean" ]
	then
		cleanarg=1
	elif [ "${arg}" = "--archive" ]
	then
		archivearg=1
	fi
done

DESTDIR=/usr/local/backup/validation
hdfsroot=/user/datalibrary/prod-e1/paxata
S3mongometa="s3://paxata-prod-east/mongo/metadata/${mongoserver}"
thedate=$(date +%Y-%m-%d)
S3validation="s3://paxata-datavalidation/${mongoserver}/${thedate}/"

# sanity check because if this is empty, some bad stuff can happen with rm
if [ -z "${DESTDIR}" ]
then
	echo "DESTDIR var is empty, to dangerous to continue..." | logger -t ${mongoserver}_hdfs_library_files
	exit 99
fi

echo "Starting HDFS validation backup" | logger -t ${mongoserver}_hdfs_library_files

# Clean the current data, otherwise we'll just allow the aws sync to overwrite/delete the data
if [[ ${cleanarg} -eq 1 ]]
then
	echo "INFO: Cleaning ${DESTDIR}" | logger -t ${mongoserver}_hdfs_library_files
	cleanUp
fi

runBackup

echo "HDFS validation backup complete" | logger -t ${mongoserver}_hdfs_library_files
