# consul_cluster

to setup this cluster of consul machines do this (requires vagrant):


git clone https://github.com/rumstattd/consul_cluster.git

cd consul_cluster

vagrant up


For mac, for linux change 'Users' to 'home'

ssh -L 8500:localhost:8500 -i /Users/INSERT-YOUR-NAME-HERE/consul_cluster/.vagrant/machines/n1/virtualbox/private_key vagrant@172.20.20.10


and then point a browser to localhost:8500
