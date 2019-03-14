#!/bin/bash

[ ! -n "${1}" ] && echo "NO IP SPECIFIED" && exit 0
IP=${1}

filename=/etc/nginx/nginx.conf
while read line;do
        flag1=`echo ${line} | awk 'NR==1{print $1}'`
        if [[ ${flag1} == *"server"* ]]
        then
                flag2=`echo ${line} | awk 'NR==1{print $2}'`
                flag2=`echo ${flag2} | awk -v FS=':' 'NR==1{print $1}'`
                if [[ "${flag2}" == "${IP}" ]]
                then
                        echo "Used IP address"
                        exit
                fi
        fi
done < $filename
sed -i "s/^    server.*$/    server "${IP}":6379;/"  /etc/nginx/nginx.conf
/usr/sbin/nginx -s reload
