#!/usr/bin/env bash

ansible-playbook -l localhost /var/lib/cloud/scripts/per-instance/host-name-provisioner/per-instance-playbook.yml
