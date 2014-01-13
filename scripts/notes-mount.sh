#!/bin/bash

mkdir -p ~/tmp/cache1

[ ! -f /dev/mapper/cache1 ] && sudo cryptsetup --type tcrypt open /home/assaf/Dropbox/Apps/EDS/cache1 cache1
mountpoint -q ~/tmp/cache1 || sudo mount -o uid=1000,gid=100 /dev/mapper/cache1 ~/tmp/cache1 

