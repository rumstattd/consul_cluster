# consul_cluster

to setup this cluster of consul machines do this (requires vagrant):


git clone https://github.com/rumstattd/consul_cluster.git

vagrant up

ssh -L 8500:localhost:8500 -i /Users/INSERT-YOUR-NAME-HERE/consul-vagrant/.vagrant/machines/server1/virtualbox/private_key vagrant@172.20.20.10


and then point a browser to localhost:8500
