#!/bin/bash
# $1: /home/assaf/wspace/swapp-test
export WORKSPACE=$1 
cd $1/build || exit
export KW_LOG_FILE=${WORKSPACE}/build/build_trace.log
export PATH=/home/kw:/usr/bin:/bin:/usr/games:/home/compass/global-scripts:/home/compass/lab-scripts
export MAKEFLAGS="-j 1"
export CCACHE_PREFIX="distcc"

which gcc
rm -f CMakeCache.txt
cmake ../src
make


