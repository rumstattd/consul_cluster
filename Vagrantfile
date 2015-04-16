# -*- mode: ruby -*-
# vi: set ft=ruby :
$script = <<SCRIPT
echo Installing dependencies...
sudo apt-get install -y unzip curl
echo Fetching Consul...
cd /tmp/
wget https://dl.bintray.com/mitchellh/consul/0.5.0_linux_amd64.zip -O consul.zip
echo Installing Consul...
unzip consul.zip
sudo chmod +x consul
sudo mv consul /usr/bin/consul
SCRIPT

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.provision "shell", inline: $script

  config.vm.define "n1" do |n1|
      n1.vm.hostname = "n1"
      n1.vm.box = "ubuntu/trusty64"
      n1.vm.network "private_network", ip: "172.20.20.10"
      n1.vm.provision "shell", path: "scripts/n1.sh"
  end

  config.vm.define "n2" do |n2|
      n2.vm.hostname = "n2"
      n2.vm.box = "ubuntu/trusty64"
      n2.vm.network "private_network", ip: "172.20.20.11"
      n2.vm.provision "shell", path: "scripts/n2.sh"
  end
    
  config.vm.define "n3" do |n3|
      n3.vm.hostname = "n3"
      n3.vm.box = "ubuntu/trusty64"
      n3.vm.network "private_network", ip: "172.20.20.12"
      n3.vm.provision "shell", path: "scripts/n3.sh"
  end
    
  config.vm.define "n4" do |n4|
      n4.vm.hostname = "n4"
      n4.vm.box = "ubuntu/trusty64"
      n4.vm.network "private_network", ip: "172.20.20.13"
      n4.vm.provision "shell", path: "scripts/n4.sh"
  end
    
  config.vm.define "n5" do |n5|
      n5.vm.hostname = "n5"
      n5.vm.box = "ubuntu/trusty64"
      n5.vm.network "private_network", ip: "172.20.20.14"
      n5.vm.provision "shell", path: "scripts/n5.sh"
  end
    
  config.vm.define "n6" do |n6|
      n6.vm.hostname = "n6"
      n6.vm.box = "ubuntu/trusty64"
      n6.vm.network "private_network", ip: "172.20.20.15"
      n6.vm.provision "shell", path: "scripts/n6.sh"
  end
end
