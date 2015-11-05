#!/bin/sh

EXE_CMD=$(readlink -f $0)
EXE_DIR=${EXE_CMD%/*}
cd "$EXE_DIR"

TS=$(date +%Y-%m-%d_%H-%M-%S)
LOG=/var/log/poweralley_starter_tests/${EXE_CMD##*/}_$TS.log
DELAY=200
RETRIES=3

if [ -z "$READY_TO_WORK" ]; then
    PIDS=$(ps ax -o pid,cmd | awk "/${EXE_CMD##*/} [M]ARK_PAUI/{printf \"%s \", \$1}")
    [ -n "$PIDS" ] && kill "$PIDS"
    export READY_TO_WORK=1
    nohup $EXE_CMD MARK_PAUI $@ >$LOG 2>1 &
    exit 0
fi

shift
version=$1
commit=$2

date

# chech package availability
echo "Checking for package 'pmm-bms-poweralleyui-tests' availability for version ${version}..."
while [ 0 -lt $RETRIES ]; do
	# sleep for $DELAY seconds to wait for package
	echo "Sleep for $DELAY seconds..."
	sleep $DELAY
	echo "Cleaning yum cache..."
	DIS=$(LANG=C yum -v -C repolist enabled | awk 'BEGIN {a=""}; /^Repo-id/{if (!match($3,"pmm-")){a=a","$3}}; END {b=substr(a,2); print b}')
	yum --disablerepo=$DIS clean all
	echo "Looking for package..."
	yum list all pmm-bms-poweralleyui-tests-${version}-* && break || true
	let RETRIES--
	echo "$RETRIES frag(s) left..."
done

# run ansible to deploy
echo "Run ansible for version $version..."
if [ -d /opt/ansible ]; then
    pushd /opt/ansible
    git pull origin
    ./deploy ci_localhost ui ${version}
    [ 0 -eq $? ] || exit 1
    popd
else
    exit 1
fi

# run tests
echo "Run tests for version $version..."
sudo -u bms -- sh /opt/poweralleyui-tests/runners/run-tests.sh $version $commit
