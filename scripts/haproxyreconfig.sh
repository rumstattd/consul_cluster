#!/bin/bash

#  script for POC consol monitoring of haproxy config and subsquent restart
#  Rick Umstattd,  rumstattd@taos.com  4/24/2015
#

watch=1

while [ $watch=1 ]; do
    result=`curl localhost:8500/v1/kv/service/haproxy/restart` >/dev/null 2>&1
    if [ $result > 0 ]; then
        service haproxy restart
        curl -X DELETE localhost:8500/v1/kv/service/haproxy/restart
    fi
    sleep 5
done
