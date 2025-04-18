#!/bin/bash
isinstalled=true
ipaddress=''
oray_vpn_address=''
isinstalledcentos()
{
if [ -a "/etc/init.d/runsunloginclient" ]; then
	echo "Installed" > /dev/null
else
	echo "Please run install.sh first"
	isinstalled=false
	exit
fi
}

isinstalledubuntu()
{
if [ -a "/etc/init/runsunloginclient.conf" ]; then
	echo "Installed" > /dev/null
else
	echo "Please run install.sh first"
	isinstalled=false
	exit
fi
}

isinstalledubuntu_hv()
{
if [ -a "/etc/systemd/system/runsunloginclient.service" ]; then
	echo "Installed" > /dev/null
else
	echo "Please run install.sh first"
	isinstalled=false
	exit
fi
}

isinstalledcentos_hv()
{
if [ -a "/etc/systemd/system/runsunloginclient.service" ]; then
	echo "Installed" > /dev/null
else
	echo "Please run install.sh first"
	isinstalled=false
	exit
fi
}

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
check_root "Installed Sunlogin client needs root to start"
ifconfig_bin='ifconfig'

if [ $os_name == 'ubuntu' ]; then
	if [ $isinstalled == true ]; then
		if [ $os_version_int -lt 15 ]; then
			isinstalledubuntu
			initctl start runsunloginclient --system
		else
			isinstalledubuntu_hv
			systemctl start runsunloginclient.service
		fi
	fi
elif [ $os_name == 'kylin' ]; then
	if [ $isinstalled == true ]; then
		isinstalledubuntu_hv
		systemctl start runsunloginclient.service
	fi
elif [ $os_name == 'debian' ]; then
	if [ $isinstalled == true ]; then
		isinstalledubuntu_hv
		systemctl start runsunloginclient.service
	fi
elif [ $os_name == 'deepin' ]; then
	if [ $isinstalled == true ]; then
		if [ $os_version_int -gt 2000 ]; then
                	let os_version_int=os_version_int-2000
        	fi
        	if [ $os_version_int -lt 15 ]; then
			isinstalledubuntu
			initctl start runsunloginclient --system
		else
			isinstalledubuntu_hv
			systemctl start runsunloginclient.service
		fi
	fi
elif  [ "$os_name" == "centos" ] || [ "$(echo $os_name |grep redhat)" != "" ] ; then
	if [ $os_version_int -lt 7 ]; then
		isinstalledcentos
		if [ $isinstalled == true ]; then
			ifconfig_bin='/sbin/ifconfig'
			#/sbin/service iptables stop
			/sbin/service runsunloginclient start
		fi
	else
		isinstalledcentos_hv
		#systemctl stop firewalld.service
		systemctl start runsunloginclient.service
	fi

else
	echo 'unknown os'
fi
/usr/local/sunlogin/scripts/host > /dev/null 2>&1
cd - > /dev/null
