#!/bin/sh
cd ${IGZ_ROOT}
mkdir -p build/x86_64/Coverage/
cd build/x86_64/Coverage/
make -i clean
cmake ../../.. -DCMAKE_BUILD_TYPE=Coverage
make -j 10
