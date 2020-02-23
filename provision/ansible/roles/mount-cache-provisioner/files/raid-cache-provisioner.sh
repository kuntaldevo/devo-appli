#!/usr/bin/env bash

ansible-playbook -l localhost /var/lib/cloud/scripts/per-instance/raid-cache-provisioner/raid-cache-provisioner-playbook.yml
