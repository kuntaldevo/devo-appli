#!/usr/bin/expect -f
# Expect script to supply root/admin password for remote ssh server
# and execute command.
# This script needs three argument to(s) connect to remote server:
# password = Password of remote UNIX server, for root user.
# ipaddr = IP Addreess of remote UNIX server, no hostname
# scriptname = Path to remote script which will execute on remote server
# For example:
#  ./sshlogin.exp password 192.168.1.11 who
# ------------------------------------------------------------------------
# Copyright (c) 2004 nixCraft project <http://cyberciti.biz/fb/>
# This script is licensed under GNU GPL version 2.0 or above
# -------------------------------------------------------------------------
# This script is part of nixCraft shell script collection (NSSC)
# Visit http://bash.cyberciti.biz/ for more information.
# ----------------------------------------------------------------------
# set Variables

# now connect to remote UNIX box (ipaddr) with given script to execute
#spawn ssh -i ~/.ssh/dev-keypair-west.pem  ec2-user@10.241.174.179

#interact

#exit

#echo "'spawn ssh gbonk@prod-jumphost01.paxata.com;expect "'Verification code:'";send "${TOKEN}\n";interact'" | xargs expect -d -c
set user [lindex $argv 0]
set token [lindex $argv 1]

spawn ssh $user@prod-jumphost01.paxata.com

expect {Verification code: }

send "$token\n";

interact
