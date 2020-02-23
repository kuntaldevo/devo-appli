#!/usr/bin/env bash

today=$(date +%Y%m%dT%H%M%S)
mkdir -p logs

bin/installation-debug-dump.sh -L -z logs/"$CUSTOMER_ID"_"$today" "$CUSTOMER_ID" "pax-installation" 