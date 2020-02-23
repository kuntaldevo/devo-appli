#!/usr/bin/expect -d -f

set token [lindex $argv 0]

spawn saml2aws login --force --skip-prompt

expect Token { send "$token\n" }
