### Create the box

<pre>
$ vagrant up
$ vagrant reload
$ vagrant ssh
$ ifconfig eth1
$ sudo su - bms
$ watch -n1 'rabbitmqctl list_queues name messages messages_ready messages_unacknowledged consumers -q | column -t | sort'
</pre>
