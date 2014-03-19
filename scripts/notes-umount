#!/bin/bash

mountpoint -q ~/tmp/cache1 && sudo umount ~/tmp/cache1
[ ! -e /dev/mapper/cache1 ] || sudo cryptsetup close cache1

