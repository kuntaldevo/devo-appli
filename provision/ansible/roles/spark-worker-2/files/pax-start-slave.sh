#!/bin/bash


SPARK_WORKER_HOST=$(hostname)

/usr/lib/spark/sbin/start-slave.sh spark://spark-master:7077 --host $SPARK_WORKER_HOST
