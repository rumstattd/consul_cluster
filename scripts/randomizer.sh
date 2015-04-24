#!/bin/bash

#  script for POC randomization of apache2 vhost config and consol monitoring config
#  Rick Umstattd,  rumstattd@taos.com  4/23/2015
#  This script requires that Apache2 is installed, and Consul is installed & running
#
#  various variables, directory and file names & locations
#
docroot=/var/www/html/index.html
apachevconf=/etc/apache2/sites-enabled/poc.conf
apacheport=/etc/apache2/ports.conf
servicename=randomhttp
consulconf=/etc/consul/config.d/randomhttp.json
randport=$(shuf -i 6000-7999 -n 1)
ipaddress=$(dig @127.0.0.1 -p 8600 `hostname`.node.consul | grep ^`hostname` | awk '{print $5}')

#  Write out Apache stuff first, an index file, then config
cat > $docroot <<ENDOFINDEX
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
  <head>
    <title>Apache2 on $ipaddress:$randport</title>
  </head>
  <body>
    <p>
       Instance Name: <b>`hostname`</b>
    </p>
    <p>
    <strong>  Apache Page on $ipaddress at port $randport </strong>
       for the Proof of Concept
    </p>
    <p>
       notice that different apache ports and addresses
       are being served by the same haproxy instance
    </p>
    <p>
       the haproxy instance has a new configuration file being reloaded with every configuration change
    </p>
    <p>
       the apache instance is being reconfigured and reloaded also.
    </p>
    <p>
       What is <b>really cool</b> is that the haproxy file is built based on the successful test of the apache
       instance by the service discovery software, consul
    </p>
  </body>
</html>
ENDOFINDEX

cat > $apachevconf <<ENDOFCONFIG
<VirtualHost $ipaddress:$randport>
   ServerAdmin webmaster@localhost
   DocumentRoot /var/www/html
   ErrorLog ${APACHE_LOG_DIR}/error.log
   CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
ENDOFCONFIG

cat > $apacheport <<ENDOFPORT
Listen 80
Listen $randport
ENDOFPORT

#  Write out consul config
cat > $consulconf <<ENDOFCONSUL
{
    "service": {
        "name": "$servicename",
        "port": $randport,
        "check": {
                "id": "http_check",
                "name": "$servicename Health Check",
   "script": "curl http://$ipaddress:$randport",
         "interval": "1s"
        }
    }
}
ENDOFCONSUL

#  Restart Apache, restart consul
/etc/init.d/apache2 restart
consul reload

#  Test to see if new service is available, and if so, set kv pair in consul
#  to notify other services of it's existence?

if [ 'curl http://$ipaddress:$randport' ] ;
   then 
     curl -X PUT http://localhost:8500/v1/kv/service/haproxy/restart
fi

#  Not in this script, but in one on the haproxy system, we'll build the template
#  and safely restart haproxy when apache config change is noticed by consul
