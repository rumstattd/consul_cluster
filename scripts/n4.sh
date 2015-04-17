#!/bin/bash
sudo mkdir /var/cache/consul /etc/consul /etc/consul/config.d
echo 'OPTIONS="-ui-dir /var/consul_web_ui"' > /etc/default/consul
sudo cat > /etc/init/consul.conf << DONE
description     "Consul agent"

start on runlevel [2345]
stop on runlevel [!2345]

respawn

script
  OPTIONS=""
  if [ -e /etc/default/consul ]
  then
    . /etc/default/consul
    echo "Sourcing config file."
  else
    echo "Config file not available."
  fi
  exec /usr/bin/consul agent -config-file /etc/consul/config.json -ui-dir /var/consul_web_ui
end script
DONE
sudo cat > /etc/consul/config.json << EOL
{
  "datacenter": "mdn1-dc",
  "data_dir": "/var/cache/consul",
  "log_level": "INFO",
  "enable_syslog": true,
  "node_name": "n4",
  "bind_addr": "0.0.0.0",
  "advertise_addr": "172.20.20.13",
  "domain": "ASA.",
  "recursor": "8.8.8.8",
  "encrypt": "p4T1eTQrIcK/MaRyrMMLzg==",
  "start_join": ["172.20.20.10", "172.20.20.11", "172.20.20.12"]
}
EOL
ln -s /lib/init/upstart-job /etc/init.d/consul
service consul stop
rm -rf /var/cache/consul/*
service consul start
