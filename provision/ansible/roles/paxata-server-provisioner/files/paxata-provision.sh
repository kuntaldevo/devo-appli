#!/usr/bin/env bash

ansible-playbook -vvv -l localhost /var/lib/cloud/scripts/per-instance/paxata-server-provisioner/paxata-server-provisioner-playbook.yml
