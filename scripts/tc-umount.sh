#!/bin/bash

mountpoint -q ~/tmp/tc2 && sudo umount ~/tmp/tc2
mountpoint -q ~/tmp/tc3 && sudo umount ~/tmp/tc3
mountpoint -q ~/tmp/tc4 && sudo umount ~/tmp/tc4
[ ! -e /dev/mapper/tc2 ] || sudo cryptsetup close tc2
[ ! -e /dev/mapper/tc3 ] || sudo cryptsetup close tc3
[ ! -e /dev/mapper/tc4 ] || sudo cryptsetup close tc4

