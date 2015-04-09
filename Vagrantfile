# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define "test1" do |test1|
    test1.vm.box = "ten0s/centos6.5_x86_64"
    test1.vm.network "private_network", ip: "192.168.100.101"
    test1.vm.network "forwarded_port", guest: 22, host: 2301
  end

  config.vm.define "test2" do |test2|
    test2.vm.box = "ten0s/centos6.5_x86_64"
    test2.vm.network "private_network", ip: "192.168.100.102"
    test2.vm.network "forwarded_port", guest: 22, host: 2302
  end
end
