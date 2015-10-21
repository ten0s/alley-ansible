### Create the box

<pre>
$ vagrant up
$ vagrant reload
$ vagrant ssh
$ ifconfig eth1
$ sudo su - bms
$ watch -n1 'rabbitmqctl list_queues name messages messages_ready messages_unacknowledged consumers -q | column -t | sort'
</pre>

# change rabbitmq_* owner to bms:bms until some supervisor is in place
ansible test -i inventories/artem -s -m shell -a 'chown -R bms:bms /var/lib/rabbitmq /var/log/rabbitmq /opt/rabbitmq*'

ansible all -i inventories/artem -s -m copy -a 'src=vagrant/frontenv-dev/alley-screen.rc dest=/home/bms/'

wget https://raw.githubusercontent.com/PowerMeMobile/kelly/develop/rel/files/http_conf.sh
ansible all -i inventories/artem -s -m copy -a 'src=vagrant/frontenv-dev/http_conf.sh dest=/home/bms/ mode=755'

vagrant ssh
sudo su - bms
./http_conf.sh

smppload -t10001 -iuser -ppassword -s375296660001 -d375296543210 -D
INFO:  Connected to 127.0.0.1:2775 (tcp)
INFO:  Bound to Funnel
INFO:  Stats:
INFO:     Send success:     1
INFO:     Send fail:        0
INFO:     Delivery success: 1
INFO:     Delivery fail:    0
INFO:     Incomings:        0
INFO:     Errors:           0
INFO:     Avg Rps:          0 mps
INFO:  Unbound
