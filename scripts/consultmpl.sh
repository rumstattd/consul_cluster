#!/bin/bash

#  script for POC on-the-fly re-write of haproxy configuration file
#  Rick Umstattd,  rumstattd@taos.com  4/23/2015
#  This script requires haproxy, and Consul is installed & running
#  This script will re-write the configuration as it changes in consul
#  the monitoing and subsquent restart happens elsewhere

consul-template -consul 127.0.0.1:8500 -template /etc/haproxy/template/haproxy.ctmpl:/etc/haproxy/haproxy.cfg
