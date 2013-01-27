#!/bin/bash

if [ -z "$WS" ]
then
  echo "\$WS is NULL - please set it to ws root (parent dir of pc2bc)"
  exit 0
fi  

if [ -z "$PC" ]
then
  echo "\$PC is NULL - please set it to ws root (parent dir of pc2bc)"
  exit 0
fi  

echo
echo "*** Building + Install + Deploy + Target-reboot: from WS $WS to PC$PC***"
echo
cd $WS/build
make install && (echo ; echo "Build OK!" ; echo ) && \
make deploy && (echo ; echo "Deploy OK!" ; echo ) && \
(ssh root@10.1.1$PC.1 /bin/reset_machine.sh) && (echo ; echo "All OK!" ; echo ) && \
date
