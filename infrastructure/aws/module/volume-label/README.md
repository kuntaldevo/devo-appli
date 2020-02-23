
Working on a new process where an Ansible playbook will wait for the cache /raid /ephemeral storage to be attached by Terraform

Once the attachment is completed the Ansible will format and mount the raid

In order to do this ( in a semi dynamic fashion ) the Ansible Script needs to know the names of the volumes to wait for while Terraform completes the attachment process.

The names were originally 'calculated' in the raid-cache module but now both Spark Worker's User Data and the Terraform Attachment needs to know the names.  Therefore it was moved here.
