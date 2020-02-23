
# Mongo Backup for Performance Data

Shell script is on prod-e1-dn4.  You can log in with the prod east keytab and ec2-user

The cron is owned by root.


```
[root@prod-e1-dn4 ec2-user]# crontab -l
5 20 * * 6 /usr/local/backup/syncFromHadoop.sh >>/var/log/backup-hdfs.log 2>&1
00 3 * * 1 /usr/local/backup/validation/get400SubsetData.sh prod-e2-mongo2 --clean >> /var/log/hdfs400subset.log 2>&1
```
