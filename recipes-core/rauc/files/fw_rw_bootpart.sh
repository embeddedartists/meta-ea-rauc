#/bin/sh

cmd="lock"

dev=`ls /dev/mmcblk*boot*`
dev=($dev)
dev=${dev[0]}
dev=${dev#/dev/mmcblk}
dev=${dev%boot*}

if [ -n "$1" ]; then
        cmd="$1"
fi

if [ ${cmd} == 'unlock' ]; then
        echo 0 > /sys/block/mmcblk${dev}boot0/force_ro
else
        echo 1 > /sys/block/mmcblk${dev}boot0/force_ro
fi

