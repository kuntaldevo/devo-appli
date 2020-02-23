#!/usr/bin/env bash

ansible-playbook -l localhost /var/lib/cloud/scripts/per-instance/{{provisioner_name}}/local-instance-playbook.yml
