#!/bin/bash
while read F; do
    if [  -e "$F" ]; then  
           echo "$F"
    fi
done
                                   
  
