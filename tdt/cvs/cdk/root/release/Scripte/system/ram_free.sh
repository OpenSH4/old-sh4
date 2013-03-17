#!/bin/sh
sync; echo 3 > /proc/sys/vm/drop_caches
sleep 10
sync; echo 3 > /proc/sys/vm/drop_caches
sleep 10
exit 0
