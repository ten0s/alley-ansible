### Create the box

<pre>
$ vagrant up
$ vagrant reload
$ vagrant ssh
$ ifconfig eth1
$ sudo su - bms
$ watch -n1 'rabbitmqctl list_queues name messages messages_ready messages_unacknowledged consumers -q | column -t | sort'
</pre>

change rabbitmq_* owner to bms:bms until some supervisor is in place
ansible all -i inventories/artem -s -m copy -a 'src=vagrant/frontenv-dev/alley-screen.rc dest=/home/bms/'

ansible all -i inventories/artem -s -m copy -a 'src=vagrant/frontenv-dev/http_conf.sh dest=/home/bms/ mode=755'

ssh vagrant@10.10.0.252 -i ~/.vagrant.d/boxes/ten0s-VAGRANTSLASH-centos6.5_x86_64/0/virtualbox/vagrant_private_key
sudo su - bms
./http_conf.sh

smppload -H10.10.0.252 -s375296660001 -d375296543210 -D