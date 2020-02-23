#!/usr/bin/env bash

ansible-playbook -vvv -l localhost /var/lib/cloud/scripts/per-instance/{{provisioner_name}}/{{provisioner_name}}-playbook.yml
