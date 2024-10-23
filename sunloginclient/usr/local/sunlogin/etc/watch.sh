#!/bin/bash

startsunloginclient() {
	/usr/local/sunlogin/bin/sunloginclient --mod=service &
}

checksunloginclient(){
	psid=$(ps -ef | grep "sunloginclient --mod=service" | grep -v grep | grep -v $0 | awk '{print $2}')
	if [ -z $psid ]; then
	startsunloginclient
	fi
}

autorun=$(awk -F '=' '/\[common\]/{a=1}a==1&&$1~/autorun/{print $2;exit}' /etc/orayconfig.conf)
if [ ! -f "/tmp/sunloginservertmp" ];then
	if [ $autorun = "0" ];then
		echo "no"
	else
		checksunloginclient
	fi
fi

if [ -f "/tmp/sunloginservertmp" ];then
	flag=$(cat /tmp/sunloginservertmp | grep client | awk -F'=' '{ print $2 }')
	if [ $flag -eq 1 ];then
		checksunloginclient;
	else
		killall sunloginclient
	fi
fi
