#!/usr/bin/expect -f
set timeout -1
spawn passwd root
expect "New password: "
send -- "Aws2020@\r"
expect "Retype new password: "
send -- "Aws2020@\r"
expect eof