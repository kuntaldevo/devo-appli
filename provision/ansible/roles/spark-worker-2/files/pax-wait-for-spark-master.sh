#!/bin/bash

WAITING_FOR="spark-master.private.vpc"
WANTED_PORT="7077"

echo "Waiting for $WAITING_FOR to launch on $WANTED_PORT..."

while ! nc -z $WAITING_FOR $WANTED_PORT; do
  sleep 1.0 # wait for 1 second before check again
done

echo "$WAITING_FOR:$WANTED_PORT has become available"
