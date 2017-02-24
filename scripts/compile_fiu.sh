#!/bin/bash

source /home/assafb/scripts/iguazio_common.sh
check_IGZ_WS
if [ $? -ne 0 ] ; then exit; fi

printf "*********************************************************\n"
printf "Workspace: ${IGZ_WS}\nBuild target: Zeek Fiu\n"
printf "*********************************************************\n"

cd ${IGZ_ZEEK}
mkdir -p build/x86_64/Fiu
cd build/x86_64/Fiu
make -i clean
cmake ${IGZ_ZEEK} -DCMAKE_BUILD_TYPE=Fiu
make -j10
