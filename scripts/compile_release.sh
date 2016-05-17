#!/bin/sh
cd ${IGZ_ROOT}
mkdir -p build/x86_64/Release/
cd build/x86_64/Release/
make -i clean
cmake ../../.. -DCMAKE_BUILD_TYPE=Release
make -j10
