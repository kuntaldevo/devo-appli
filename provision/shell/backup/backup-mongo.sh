#! /bin/sh
export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:$PATH
usage="\nUsage is: backup-mongo.sh <Hostname> <Dev, Trial or Prod> <Region>\n\tExample: backup.sh prod-e1-mongo2 prod east\n"

#Check to make sure all varibles were provided, if not quit and provide usage
if [[ -z $1 ]] | [[ -z $2 ]] | [[ -z $3 ]]
then
  echo -e "$usage"
  exit
fi
#Read CLI variables into script and convert to lower case
hostname=`echo $1 | awk '{print tolower($0)}'`
stype=`echo $2 | awk '{print tolower($0)}'`
region=`echo $3 | awk '{print tolower($0)}'`

#export AWS_ACCESS_KEY_ID=
#export AWS_SECRET_ACCESS_KEY=
export AWS_DEFAULT_REGION=us-east-1
export COMMAND="aws s3 sync --sse --exclude '*indices/*'"
export MONGOBASE=/root/backups/mongo
export MONGOPATH=$MONGOBASE/mongodump/`date +%m-%d`
export BACKUPPATH=/root/backups/mongo/mongodump-`date +%m-%d`.tgz
export S3PATH=s3://paxata-${stype}-${region}/mongo/${hostname}/

echo -e "\nStarting backup on: `date +%F`"|logger -t mongodb_backup

CMD=""

set_command() {
    ADMIN=$(grep user: /root/.pax-mongo.yaml | cut -d: -f2|sed 's/"//g')
    PASS=$(grep assword: /root/.pax-mongo.yaml|cut -d: -f2|sed 's/"//g')

    if [ -z "$ADMIN" ] || [ -z "$PASS" ]; then
      CMD="/usr/bin/mongodump --host localhost"
      #CMD2="/usr/bin/mongo --quiet --host localhost"
      CMD2="/usr/bin/mongo --quiet"
    elif [ ! -z "$ADMIN" ] && [ ! -z "$PASS" ]; then
      CMD="/usr/bin/mongodump -u $ADMIN -p $PASS --authenticationDatabase admin --host $hostname"
      CMD2="/usr/bin/mongo --quiet -u $ADMIN -p $PASS --authenticationDatabase admin"
    fi
}

DB=paxata
set_command

if [ ! -f /root/backups/mongo/mongodump-$(date +%m-%d).tgz ]
then
	echo -e "\nDeleting any old backup"|logger -t mongodb_backup
	rm -rf $MONGOBASE/*

	echo -e "\nDumping Mongo $DB"|logger -t mongodb_backup

	$CMD --out $MONGOPATH --db "$DB"|logger -t mongodb_backup

	which md5deep &> /dev/null
	if [ $? -ne 0 ]; then
	        yum -y --quiet md5deep
	fi

	mkdir -p $MONGOBASE/mongodump
	cd $MONGOBASE/mongodump
	md5deep -r * | tee mongodump_md5sum_$(date +%m-%d).txt

	echo -e "\nCompressing backup"|logger -t mongodb_backup
	tar -czf $BACKUPPATH $MONGOPATH $MONGOBASE/mongodump/mongodump_md5sum_$(date +%m-%d).txt | logger -t mongodb_backup

	echo -e "\nUploading to $S3PATH"|logger -t mongodb_backup
	aws s3 cp $BACKUPPATH $S3PATH |logger -t mongodb_backup
else
	echo -e "\nA backup for today $(date +%m-%d) already exists so skipping mongodb backup" | logger -t mongodb_backup
fi

# HDFS mongo metadata retrieval
echo -e "\nRetrieving mongo metadata for top 400 projects." | logger -t mongodb_backup

# Retrieve meta data for the hdfs library file locations
username=$(grep user: /root/.pax-mongo.yaml | cut -d: -f2 | sed 's/"//g;s/ //g')
password=$(grep assword: /root/.pax-mongo.yaml|cut -d: -f2 | sed 's/"//g;s/ //g')
today=$(date +%m-%d)
projectlist=/root/backups/mongo/prod-project-lists-${today}.txt
libraryfile=/root/backups/mongo/prod-library-files-${today}.txt
day7files=/root/backups/mongo/all-7day-files-${today}.txt
day7latest=/root/backups/mongo/7day-latest-version-${today}.txt
previewpaths=/root/backups/mongo/preview-upload-paths-${today}.txt
S3metadata=s3://paxata-${stype}-${region}/mongo/metadata/${hostname}/

[ -z "${username}" ] && echo "Unable to rerieve username for DB" && exit 1
[ -z "${password}" ] && echo "Unable to rerieve password for DB" && exit 1

rm -f /tmp/projectFiles /tmp/filePaths ${projectlist} ${libraryfile}

# Lets get the master node because these queries won't work on a secondary server in the cluster
HOST=$(${CMD2} --host localhost paxata --eval 'rs.isMaster().primary')
[ -z "${HOST}" ] && HOST=localhost

${CMD2} --host ${HOST} ${DB} --eval 'db.projects.find({}).sort({updated: -1}).limit(400).forEach(function(myDoc) {print(myDoc._id);})' > ${projectlist} 2>&1

cat ${projectlist} |
while read line
do
	${CMD2} --host ${HOST} ${DB} --eval 'db.projectVersions.find({projectId: "'`echo $line | awk -F '_' '{print $1}'`'"},{"script.steps.importStep.libraryIdWithVersion": 1, "script.steps.steps.libraryIdWithVersion": 1}).sort({editTime: -1}).limit(1).pretty().shellPrint()' >> /tmp/projectFiles
done

for i in `cat /tmp/projectFiles | grep libraryIdWith | awk -F '" : "' '{print $2}' | tr -d '"'`
do
	${CMD2} --host ${HOST} ${DB} --eval 'db.datafiles.find({dataFileId: "'`echo $i | awk -F '_' '{print $1}'`'", version: '`echo $i | awk -F '_' '{print $2}'`'}, {path: 1}).limit(1).forEach(function(myDoc) {print(myDoc.path);})' >> /tmp/filePaths
done

grep library/ /tmp/filePaths > ${libraryfile}

# retrieve files created in last 7 days
days=$(expr `date +%s` - 604800)
createtime=$(expr ${days} \* 1000)
q1="db.datafiles.find({createTime: {\$gte: "${createtime}"}, dataFileId: {\$nin: ['2fd20cc3163b4c5e826b93843b37c7a9','b4c2336df737407d9f031e2b53297b40'] }},{_id: 0, path: 1}).forEach(function(myDoc) {print(myDoc.path);})"
${CMD2} --host ${HOST} ${DB} --eval "${q1}" > ${day7files}

# retrieve the latest version from the last 7 days files
rm -f ${day7latest}
awk -F\/ '{print $4}' ${day7files} | sort | uniq |
while read id j;
do
        q2="db.datafiles.find({dataFileId: \"${id}\"},{_id: 0, path: 1}).sort({version: -1}).limit(1).forEach(function(myDoc) {print(myDoc.path);})"
        ${CMD2} --host ${HOST} ${DB} --eval "${q2}" >> ${day7latest}
done
sed -i -e '/unknown type/d' ${day7files}
sed -i -e '/unknown type/d' ${day7latest}

# retrieve library files in PREVIEW state from 'upload' dir over last 7 days
pr1="db.datafiles.find({createTime: {\$gte: ${createtime}}, acquisitionState: \"PREVIEW\", \"processingState.path\": {\$nin: [null]}},{"_id": 0, \"processingState.path\": 1}).forEach(function(myDoc) {print(myDoc.processingState.path);})"
${CMD2} --host ${HOST} ${DB} --eval "${pr1}" > ${previewpaths}

echo "Uploading project list to ${S3metadata}" | logger -t mongodb_backup
aws s3 cp ${projectlist} ${S3metadata} | logger -t mongodb_backup
aws s3 cp ${day7files} ${S3metadata} | logger -t mongodb_backup

echo "Uploading library files list to ${S3metadata}" | logger -t mongodb_backup
aws s3 cp ${libraryfile} ${S3metadata} | logger -t mongodb_backup
aws s3 cp ${day7latest} ${S3metadata} | logger -t mongodb_backup

echo "Uploading preview upload paths to ${S3metadata}" | logger -t mongodb_backup
aws s3 cp ${previewpaths} ${S3metadata} | logger -t mongodb_backup

echo "Mongo backup complete" | logger -t mongodb_backup
