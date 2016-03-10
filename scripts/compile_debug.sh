#!/bin/sh

mkdir -p build/x86_64/Debug/
cd build/x86_64/Debug/
make -i clean
cmake ../../.. -DCMAKE_BUILD_TYPE=Debug
make -j10
