#!/bin/bash
for ((i=0;i<50;i++));
do touch /tmp/fuse_mount/testdir/file$i &
done
