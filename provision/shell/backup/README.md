
Running on `prod-e2-mongo2` ( 10.10.25.159 ) this appears to find the 400 latest projects

Grabbing credentials stored in `cat /root/.pax-mongo.yaml`

This writes the files, prod-library-files , prod-project-lists etc that are consumed by the scripts in ../perf-backup

```
[root@prod-e2-mongo2 ~]# cat /etc/cron.d/backup-mongo
30 1 * * * root /root/cli-tools/backup-mongo.sh prod-e2-mongo2 prod east >>/var/log/backup-mongo.log 2>&1
00 2 * * * root /root/cli-tools/backup-mongo2.sh >>/var/log/backup-mongo-duply.log 2>&1[root@prod-e2-mongo2 ~]#
```

# Logs

`cat /var/log/messages | grep mongodb_backup`
