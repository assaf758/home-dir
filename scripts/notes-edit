#!/bin/bash

mkdir -p ~/tmp/cache1

[ ! -f /dev/mapper/cache1 ] && sudo cryptsetup --type tcrypt open ~assaf/Dropbox/Apps/EDS/cache1 cache1
sudo mount -o uid=1000,gid=100 /dev/mapper/cache1 ~/tmp/cache1/ 
vim ~/tmp/cache1/notes.txt 
sudo umount ~/tmp/cache1 
sudo cryptsetup close cache1

