#!/bin/bash
# <bitbar.title>Open/Close TUN</bitbar.title>
# <bitbar.version>v0.1</bitbar.version>
# <bitbar.author>lalawue</bitbar.author>
# <bitbar.author.github>lalawue</bitbar.author.github>
# <bitbar.image>http://i.imgur.com/EDYR52G.png</bitbar.image>
# <bitbar.desc>open/close tun</bitbar.desc>
TUN_DIR=/tmp/tun
TUN_FILE=$TUN_DIR/mon_tun.sched
PID_FILE=$TUN_DIR/mon_sched.pid

# create sched spec
mkdir -p $TUN_DIR

# menu
echo "TUN"
echo "---"

if [[ "$1" = "start" ]]; then
echo '{
        "name" : "tun_sched",
        "logfile" : "/tmp/tun/mon_sched.log",
        "pidfile" : "/tmp/tun/mon_sched.pid",
        "daemon" : true,
        "service_tun" : {
                "cmd": "exec $HOME/bin/tun_local.out -l '127.0.0.1:?' -r '?:?' -u '?' -p '?' -verbose 3 > /dev/null",
                "attempts": 99999,
                "sleep": 1
        }
}' > $TUN_FILE
exec $HOME/bin/mon_sched -r $TUN_FILE

elif [[ "$1" = "stop" ]]; then

	$HOME/bin/mon_sched -k $PID_FILE

else
	echo "hello" > /dev/null
fi

if [ -f $PID_FILE ]; then
	echo "Stop TUN | bash='$0' param1=stop terminal=false"
else
	echo "Start TUN | bash='$0' param1=start terminal=false"
fi
