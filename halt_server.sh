#!/usr/bin/expect
#
# create in 2013/12/31, by sucha in http://suchang.net
#
# Usage: halt_server host_ip

# prompt for root@host_ip
set serv_root_prompt "password"
set serv_halt_cmd "shutdown -P now" # just power off, later we can wake on lan (WOL)
set serv_halt_expect "power"

set timeout 10
if { $argc != 1 } {
	send_user "$argv0 \$HOST_IP\n"
	exit
}

# get server ip
set host [lrange $argv 0 0]

# get root's passwd
stty -echo
send_user -- "Password for root@$host: "
expect_user -re "(.*)\n"
send_user "\n"
set pass $expect_out(1,string)

# login server and run halt
spawn ssh -2 root@$host
expect $serv_root_prompt
send $pass\r
send $serv_halt_cmd\r
expect $serv_halt_expect
exit
