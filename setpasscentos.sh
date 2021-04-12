#!/usr/bin/expect -f
set timeout -1
spawn passwd centos
expect "New password: "
send -- "Aws2020@\r"
expect "Retype new password: "
send -- "Aws2020@\r"
expect eof