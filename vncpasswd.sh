#!/usr/bin/expect -f
set timeout -1
spawn vncpasswd
expect "Password:"
send -- "Aws2020@\r"
expect "Verify:"
send -- "Aws2020@\r"
expect "Would you like to enter a view-only password (y/n)?"
send -- "n\r"
expect eof