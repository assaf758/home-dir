#!/bin/bash

if [ -z "$WS" ]
then
  echo "\$WS is NULL - please set it to ws root (parent dir of pc2bc)"
  exit 0
fi     # $WS is NULL.


rm $WS/cscope.files 2>/dev/null
cd /

find -L $WS/src $WS/tools/ \
/home/compass/platform-releases/trunk/r380/sysroot/usr/include/ \
/home/compass/confd/confd-3.3/full_lib/libconfd/ \
\( -path $WS/src/np/ez_sdk/\* -o -path $WS/target_dir/\* -o -path $WS/my_slick/\* \) -prune  -o -type f  -printf \"%p\"\\n   | \
grep -Ev ".*((~$)|(\.(obj|mak|dsp|exe|html|gif|tgz|gz|soc|ko|so|a|o|d|out|diff|patch|zip)\"$)|(\.CC|\/\.))" > $WS/cscope.files

mkdir --parents $WS/my_slick
rm -rf $WS/my_slick/*

# find (-path <don't want this> -o -path <don't want this#2>) 
# \-prune -o -path <global expression for what I do want>
# find . -follow | grep -E ".*\.(c|h|S|sh|pl|xml|def)$" >> ${FILE}


