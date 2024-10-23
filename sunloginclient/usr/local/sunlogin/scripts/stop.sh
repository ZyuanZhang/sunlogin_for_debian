#!/bin/bash

#change directory to script path
curpath=$(cd "$(dirname "$0")"; pwd)
cd $curpath > /dev/null

source /usr/local/sunlogin/scripts/common.sh
os_version_int=${os_version%.*}
for i in $(seq 1 10)
do
	os_version_int=${os_version_int%.*}
done

#check root
check_root "Installed Sunlogin client needs root to stop"

if [ "$os_name" == "ubuntu" ]; then
	if [ $os_version_int -lt 15 ]; then
		initctl stop runsunloginclient --system
	else
		systemctl stop runsunloginclient.service
	fi
elif [ "$os_name" == "kylin" ]; then
	systemctl stop runsunloginclient.service
elif [ "$os_name" == "debian" ]; then
	systemctl stop runsunloginclient.service
elif [ "$os_name" == "deepin" ]; then
	if [ $os_version_int -gt 2000 ]; then
		let os_version_int=os_version_int-2000
        fi
        if [ $os_version_int -lt 15 ]; then
                initctl stop runsunloginclient --system
        else
                systemctl stop runsunloginclient.service
        fi
elif  [ "$os_name" == "centos" ] || [ "$(echo $os_name |grep redhat)" != "" ] ; then
	if [ $os_version_int -lt 7 ]; then
		/sbin/service runsunloginclient stop
	else
		systemctl stop runsunloginclient.service
	fi

else
	echo 'unknown os'

fi

killall sunloginclient

echo "Sunlogin stopped"

cd - > /dev/null
