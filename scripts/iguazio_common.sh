#!/bin/bash

# worksapce vars management

igset_ws_root ()
{
    [ $# -eq 0 ] && { echo "Usage: ${FUNCNAME} target // target = [Debug | Fiu | Release]"; return 1; }
    local target="$1"
    export IGZ_WS_NAME=$(basename $(pwd))
    export IGZ_WS=$(pwd)
    export IGZ_ZEEK=${IGZ_WS}/engine/zeek
    export ROOT_SRC_DIR=${IGZ_ZEEK}
    export ROOT_BIN_DIR=${ROOT_SRC_DIR}/build/x86_64/${target}
    igc
}

igc ()
{
    echo "IGZ_WS_NAME = ${IGZ_WS_NAME}"
    echo "IGZ_WS = ${IGZ_WS}"
    echo "IGZ_ZEEK = ${IGZ_ZEEK}"
    echo "ROOT_SRC_DIR = ${ROOT_SRC_DIR}"
    echo "ROOT_BIN_DIR = ${ROOT_BIN_DIR}"
}

check_IGZ_WS ()
{
    local result=0
    if [ -z ${IGZ_WS+x} ]; then echo "IGZ_WS is unset. Please set it to workspace root (for ex. ~/iguazio/ws). igset_ws_root() can be used"; local result=1;  fi
    return ${result}
}

igtmux ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    tmuxinator start code  -n ${IGZ_WS_NAME} workspace=$IGZ_ZEEK
}

igrun_test ()
{
    check_IGZ_WS
    if [ $# -lt 1 ] ; then echo "plese provide path for test to run (and optional params to it)"; return 1; fi
    test=$1
    shift
    cd ${IGZ_ZEEK}
    source ${ROOT_SRC_DIR}/venv/bin/activate
    igkillall 
    rm /dev/shm/*_stats_*
    find /tmp -name 'data_policy_container_*' -delete
    LD_LIBRARY_PATH=${ROOT_BIN_DIR}/v3io python "$test" ${ROOT_SRC_DIR} ${ROOT_BIN_DIR} "$@"
    local result=$?
    deactivate 
    return ${result}
}

igkillall ()
{
    kill -9 `pidof v3io_adapters_fuse` `pidof bridge` >& /dev/null
    kill -9 `pidof v3io_daemon` `pidof log_server` >& /dev/null
    kill -9 `pidof nginx` `pidof xio_mule`  >& /dev/null
    kill -9 `pidof valgrind.bin` `pidof valgrind` >& /dev/null
    kill -9 `pidof -x run_node_services.sh` `pidof valgrind` >& /dev/null
    ps axu | awk '/integration\.sh/ {print $2}' | xargs kill -9 >& /dev/null
    kill -9 `pidof fio` >& /dev/null
    pkill -9 node_runner* >& /dev/null
    rm -f /dev/shm/*_stats_* # remove old stats files
    rm -rf /tmp/fuse_mount /tmp_fuse_mount_all
}

# change-dir shortcuts

cdws ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_WS}
}

cdzeek ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}
}

cdbuild ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}/build
}

cdrelease ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}/build/x86_64/Release
}

cddebug ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}/build/x86_64/Debug
}

cdfiu ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}/build/x86_64/Fiu
}

cdtesting ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    cd ${IGZ_ZEEK}/testing/integration
}

