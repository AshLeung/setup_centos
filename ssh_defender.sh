#!/bin/sh

LOG_PATH=/var/log/secure
BLACKLIST_PATH=/tmp/sshblacklist.txt
MAX_RETRY=5

if [ ! -f $LOG_PATH ];then
	echo "SSH log file not exist!"
	exit 1
fi

if [ ! -f $BLACKLIST_PATH ]; then
	touch $BLACKLIST_PATH
fi

cat $LOG_PATH |awk '/Failed/{print $(NF-3)}'|sort|uniq -c|awk '{print $2"="$1;}' > $BLACKLIST_PATH

echo "doing add ssh blacklist."

for i in `cat $BLACKLIST_PATH` 
do
	ip=`echo $i |awk -F= '{print $1}'`
	num=`echo $i|awk -F= '{print $2}'`
	if [ $num -gt $MAX_RETRY ]; then
		grep $ip /etc/hosts.deny > /dev/null && continue
		echo "sshd:$ip" >> /etc/hosts.deny
	fi
done

echo "done."
