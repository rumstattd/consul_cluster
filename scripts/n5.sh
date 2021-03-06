#!/bin/bash
sudo mkdir /var/cache/consul /etc/consul /etc/consul/config.d
cp /vagrant/scripts/http.json /etc/consul/config.d
cp /vagrant/scripts/randomizer.sh /etc/init.d
ln -s /etc/init.d/randomizer.sh /etc/rc2.d/S99randomizer
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
  exec /usr/bin/consul agent -config-file /etc/consul/config.json -config-dir /etc/consul/config.d -ui-dir /var/consul_web_ui
end script
DONE
sudo cat > /etc/consul/config.json << EOL
{
  "datacenter": "mdn1-dc",
  "data_dir": "/var/cache/consul",
  "log_level": "INFO",
  "enable_syslog": true,
  "node_name": "n5",
  "bind_addr": "0.0.0.0",
  "advertise_addr": "172.20.20.14",
  "encrypt": "p4T1eTQrIcK/MaRyrMMLzg==",
  "start_join": ["172.20.20.10", "172.20.20.11", "172.20.20.12"]
}
EOL
ln -s /lib/init/upstart-job /etc/init.d/consul
service consul stop
rm -rf /var/cache/consul/*
service consul start
sleep 1
/etc/init.d/randomizer.sh
