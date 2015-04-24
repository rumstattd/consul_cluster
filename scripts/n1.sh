#!/bin/bash
sudo mkdir /var/cache/consul /etc/consul /etc/consul/config.d /var/consul_web_ui
apt-get install haproxy
mkdir /etc/haproxy/template
cp /vagrant/bin/consul-template /usr/bin
cp /vagrant/scripts/haproxy.ctmpl /etc/haproxy/template
cp /vagrant/scripts/haproxyreconfig.sh /etc/init.d
cp /vagrant/scripts/consultmpl.sh /etc/init.d
cp /vagrant/scripts/http.json /etc/consul/config.d
cp /vagrant/scripts/randomizer.sh /etc/init.d
ln -s /etc/init.d/consultmpl.sh /etc/rc2.d/S99consultmpl
ln -s /etc/init.d/haproxyreconfig.sh /etc/rc2.d/S99haproxyreconfig
ln -s /etc/init.d/randomizer.sh /etc/rc2.d/S99randomizer
wget https://dl.bintray.com/mitchellh/consul/0.5.0_web_ui.zip -O /var/consul_web_ui/0.5.0_web_ui.zip
unzip /var/consul_web_ui/0.5.0_web_ui.zip -d /var/consul_web_ui/
mv /var/consul_web_ui/dist/* /var/consul_web_ui/
rm -fR /var/consul_web_ui/dist/ 
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
  "node_name": "n1",
  "bind_addr": "0.0.0.0",
  "advertise_addr": "172.20.20.10",
  "encrypt": "p4T1eTQrIcK/MaRyrMMLzg==",
  "server": true,
  "bootstrap": true
}
EOL
ln -s /lib/init/upstart-job /etc/init.d/consul
service consul stop
rm -rf /var/cache/consul/*
service consul start
sleep 1
/etc/init.d/randomizer.sh
