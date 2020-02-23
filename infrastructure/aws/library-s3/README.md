
# Library storage in S3

Create the library for a given 'ENV-KEY' in s3.

This configuration uses the remote-up override feature

>  remote-up.sh library-s3

The ENV-KEY's remote state storage typically a tfstate.* named bucket that was created by 'remote-init'

To destroy the command is familiar,

>  remote-down.sh library-s3
