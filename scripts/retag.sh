#!/bin/bash
VS=/auto/software/tools/slickedit-15.0.5/bin/vs 
WS=/home/assaf/wspace/ws-tmp
$VS +new -p make-tags  -L $WS/cscope.files -X -O $WS/my_slick/my_proj.vtg

