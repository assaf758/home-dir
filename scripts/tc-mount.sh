#!/bin/bash

mkdir -p ~/tmp/tc2
mkdir -p ~/tmp/tc3
mkdir -p ~/tmp/tc4

[ ! -f /dev/mapper/tc2 ] && sudo cryptsetup --type tcrypt open /home/assaf/robot/c2 tc2
[ ! -f /dev/mapper/tc3 ] && sudo cryptsetup --type tcrypt open /home/assaf/robot/c3 tc3
[ ! -f /dev/mapper/tc4 ] && sudo cryptsetup --type tcrypt open /home/assaf/robot/c4 tc4
mountpoint -q ~/tmp/tc2 || sudo mount -o uid=1000,gid=100 /dev/mapper/tc2 ~/tmp/tc2 
mountpoint -q ~/tmp/tc3 || sudo mount -o uid=1000,gid=100 /dev/mapper/tc3 ~/tmp/tc3
mountpoint -q ~/tmp/tc4 || sudo mount -o uid=1000,gid=100 /dev/mapper/tc4 ~/tmp/tc4 

