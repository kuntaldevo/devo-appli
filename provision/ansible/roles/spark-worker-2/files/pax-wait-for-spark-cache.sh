#!/bin/bash

WAITING_FOR="/mnt/cache"

echo "Waiting for $WAITING_FOR device to be ready..."

while ! mountpoint -q $WAITING_FOR; do
  sleep 1.0 # wait for 1 second before check again
done

echo "Device $WAITING_FOR has become available"
