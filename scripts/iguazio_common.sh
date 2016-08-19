#!/bin/bash

# worksapce vars management

igset_ws_root ()
{
    export IGZ_WS_NAME=$(basename $(pwd))
    export IGZ_WS=$(pwd)
    export IGZ_ZEEK=${IGZ_WS}/engine/zeek
    igc
}

igc ()
{
    echo "IGZ_WS_NAME = ${IGZ_WS_NAME}"
    echo "IGZ_WS = ${IGZ_WS}"
    echo "IGZ_ZEEK = ${IGZ_ZEEK}"
}

check_IGZ_WS ()
{
    local result=0
    if [ -z ${IGZ_WS+x} ]; then echo "IGZ_WS is unset. Please set it to workspace root (for ex. ~/iguazio/ws)."; local result=1;  fi
    return ${result}
}

# change-dir shortcuts

cdw ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_WS}
}

cdr ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}
}

cdd ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}/build/x86_64/Debug
}

igtmux ()
{
    tmuxinator start code  -n ${IGZ_WS_NAME} workspace=$IGZ_ZEEK
}

#ex - setting string return val
# check_IGZ_WS ()
# {
#     local __resultvar=$1
#     local __myresult='0'
#     if [ -z ${IGZ_WS+x} ]; then echo "IGZ_WS is unset. Please set it to workspace root (for ex. ~/iguazio/ws)."; myresult='1' ;fi
#     eval $__resultvar="'$myresult'"
# }

