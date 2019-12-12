#!/bin/bash

source /home/assafb/scripts/iguazio_common.sh
check_IGZ_WS
if [ $? -ne 0 ] ; then exit; fi

printf "*********************************************************\n"
printf "Workspace: ${IGZ_WS}\nBuild target: Zeek Debug\n"
printf "*********************************************************\n"

cd ${IGZ_ZEEK}
mkdir -p build/x86_64/Debug/
cd build/x86_64/Debug/
make -i clean
rm -rf * .*
cmake ${IGZ_ZEEK} -DCMAKE_BUILD_TYPE=Debug

# make VERBOSE=1 -j 6
make -l $(nproc)
