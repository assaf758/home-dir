#!/bin/bash

source /home/assafb/scripts/iguazio_common.sh
check_IGZ_WS
if [ $? -ne 0 ] ; then exit; fi

printf "*********************************************************\n"
printf "Workspace: ${IGZ_WS}\nBuild target: Zeek Release\n"
printf "*********************************************************\n"

cd ${IGZ_ZEEK}
mkdir -p build/x86_64/Release
cd build/x86_64/Release/
make -i clean
cmake ${IGZ_ZEEK} -DCMAKE_BUILD_TYPE=Release
make -j10
