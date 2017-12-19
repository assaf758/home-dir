#!/bin/bash

while true; do 
    echo 'now building'; 
    make -j 6  |& tee ${IGZ_ZEEK}/make.log
    if (("${PIPESTATUS[0]}" > 0)); then 
        less  --quit-on-intr -p 'In function' ${IGZ_ZEEK}/make.log
        if (($? > 0)); then
            break
        fi
    else
        clear
        echo 'all good'
        break
    fi 
done
