#!/bin/bash

source /home/assafb/scripts/iguazio_common.sh
check_IGZ_ROOT
if [ $? -ne 0 ] ; then exit; fi

cd ${IGZ_ROOT}
mkdir -p build/x86_64/Debug/
cd build/x86_64/Debug/
make -i clean
cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Debug -D CMAKE_C_COMPILE='/home/assafb/ws/build/include-what-you-use --check_also="*.c"' -D CMAKE_CXX_COMPILE='~/ws/build/include-what-you-use --check_also="*.c"' ${IGZ_ROOT} 
make VERBOSE=1 
