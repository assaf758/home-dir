#!/bin/bash
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
for file in $( ls ~/Dropbox/persistent_history*); do
    echo "adding $file"
    cat ${file} >> /tmp/persistent_history
    rm ${file}
done
sort -u /tmp/persistent_history -o /tmp/persistent_history
mv /tmp/persistent_history ~/Dropbox/persistent_history
IFS=$SAVEIFS
