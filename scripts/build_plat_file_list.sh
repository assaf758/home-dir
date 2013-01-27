
#!/bin/bash

if [ -z "$WS" ]
then
  echo "\$WS is NULL - please set it to ws root (parent dir of pc2bc)"
  exit 0
fi     # $WS is NULL.


rm $WS/cscope.files 2>/dev/null
cd /
find -L $WS/src \
\( -path $WS/target_dir/\* -o -path $WS/my_slick/\* \) -prune  -o -type f -print | \
grep -Ev ".*((~$)|(\.(html|gif|tgz|ko|so|a|o|d|out|diff|patch|zip)$)|(\.CC|\/\.))" > $WS/cscope.files


# find (-path <don't want this> -o -path <don't want this#2>) 
# \-prune -o -path <global expression for what I do want>
# find . -follow | grep -E ".*\.(c|h|S|sh|pl|xml|def)$" >> ${FILE}


