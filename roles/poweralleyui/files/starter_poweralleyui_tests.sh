#!/bin/sh

EXE_CMD=$(readlink -f $0)
EXE_DIR=${EXE_CMD%/*}
cd "$EXE_DIR"

TS=$(date +%Y-%m-%d_%H-%M-%S)
LOG=/var/log/poweralley_starter_tests/${EXE_CMD##*/}_$TS.log
DELAY=200

if [ -z "$READY_TO_WORK" ]; then
	PIDS=$(ps ax -o pid,cmd | awk "/${EXE_CMD##*/} [M]ARK_PAUI/{printf \"%s \", \$1}")
	[ -n "$PIDS" ] && kill "$PIDS"
	export READY_TO_WORK=1
	nohup $EXE_CMD MARK_PAUI $@ >$LOG 2>1 &
	exit 0
fi

shift

date

# sleep for $DELAY seconds to wait for package
echo "Sleep for $DELAY seconds..."
sleep $DELAY

# run ansible to deploy
echo "Run ansible for version $version..."
version=$1
if [ -d /opt/ansible ]; then
	pushd /opt/ansible
	./deploy ci_localhost ui ${version}
	[ 0 -eq $? ] || exit 1
#	sudo -u root -- sh -c "cd /opt/ansible && ./deploy ci_localhost ui ${version}"
	popd
else
	exit 1
fi

# run tests
echo "Run tests for version $version..."
sudo -u bms -- /opt/poweralleyui-tests/runners/run-tests.sh $version
