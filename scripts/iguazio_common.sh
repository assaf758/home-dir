#!/bin/bash

# worksapce vars management

igset_traget ()
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
    if [ -z ${IGZ_WS+x} ]; then echo "IGZ_WS is unset. Please set it to workspace root (for ex. ~/iguazio/ws). igset_traget() can be used"; local result=1;  fi
    return ${result}
}

igtmux ()
{
    check_IGZ_WS
    if [ $? -ne 0 ] ; then return 1; fi
    tmuxinator start code  -n ${IGZ_WS_NAME} workspace=$IGZ_ZEEK
}


igws ()
{
    if [[ $# < 1  || $# > 2 ]] ; then echo "usage: igws <workspace> [<target>]. for example igws resync Release"; return 1; fi
    target="Debug"
    if [ $2 ] ; then target=$(echo $2) ; fi
    cd ~/iguazio/$1 && igset_traget "${target}" && unset DISPLAY && igtmux
}


igrun_test ()
{
    check_IGZ_WS
    if [ $# -lt 1 ] ; then echo "plese provide path for test to run (and optional params to it)"; return 1; fi
    igc
    test=$1
    shift
    cd ${IGZ_ZEEK}
    source ${ROOT_SRC_DIR}/venv/bin/activate
    local iter
    local result
    if [ -z ${ITERATIONS:+x} ]; then iter=1; else iter=$ITERATIONS; fi
    for ((i=1;i<=$iter;i++))
    do
        igkillall
        # rm ${ROOT_BIN_DIR}/valgrind_results/*
        printf "running iteration #%d/%d of test %s\n" ${i} ${iter} ${test}
        LD_LIBRARY_PATH=${ROOT_BIN_DIR}/v3io python "$test" ${ROOT_SRC_DIR} ${ROOT_BIN_DIR} "$@"
        result=$?
        if ((${result}!=0)); then printf "test number %d failed rc=%d" ${i} ${result}; break; fi
    done
    deactivate 
    return ${result}
}

igkillall ()
{
    kill -9 `pidof v3io_adapters_fuse` `pidof bridge` >& /dev/null
    kill -9 `pidof object_put_spammer` >& /dev/null
    kill -9 `pidof v3io_daemon` `pidof log_server` >& /dev/null
    kill -9 `pidof nginx` `pidof xio_mule`  >& /dev/null
    kill -9 `pidof valgrind.bin` `pidof valgrind` >& /dev/null
    kill -9 `pidof -x run_node_services.sh` `pidof valgrind` >& /dev/null
    pkill -9  >& /dev/null
    ps axu | awk '/integration\.sh/ {print $2}' | xargs kill -9 >& /dev/null
    ps axu | awk '/integration\/run\.py/ {print $2}' | xargs kill -9 >& /dev/null
    ps axu | awk '/testing\/integration\/tests/ {print $2}' | xargs kill -9 >& /dev/null
    kill -9 `pidof fio` >& /dev/null
    pkill -9 node_runner* >& /dev/null
    rm -f /dev/shm/*_stats_* # remove old stats files
    rm -rf /tmp/fuse_mount /tmp_fuse_mount_all /tmp/bridge_*
    rm -rf /tmp/igzfs/
    find /tmp -name 'data_policy_container_*' -delete
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

ig_format ()
{
    (cdzeek && docker run -it -u assafb -w $(pwd) --rm --name test -v ~/iguazio:/home/assafb/iguazio assafb/ubuntu-16.04-clang-3.6 ./etc/scripts/format_code)
}

set_lemonade()
{
    tmup

    local info_str
    local orig_port
    local new_port

    printf "SSH_CLIENT = %s\n" "${SSH_CLIENT}"
    if [[ ${SSH_CLIENT} =~ 192.168.10[16] ]] ; then
       info_str='connecting from home hlinux'
       orig_port='2489'
       new_port='2490'
    else
       info_str='connecting from office wlinux'
       orig_port='2490'
       new_port='2489'
    fi

    printf "%s, %s->%s\n" "${info_str}" $orig_port $new_port
    sed -i  "s/${orig_port}/${new_port}/g" ~/.config/lemonade.toml

    echo y | lemonade copy
    if [ $? -ne 0 ] ; then
        printf "lemonade test FAIL\n"
    else
        printf "lemonade test OK\n"
    fi
    # if can't connect:
    # sudo netstat -apn|grep -w 2490  | awk '{print $7}' | cut -d '/' -f 1 | xargs kill -9
}
