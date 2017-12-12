#!/usr/bin/python
import time
import subprocess
import os
import datetime
from distutils.spawn import find_executable
import signal

def do_every(period,f,*args):
    def g_tick():
        t = time.time()
        count = -1
        while True:
            count += 1
            yield max(t + count*period - time.time(),0)
    g = g_tick()
    while True:
        time.sleep(next(g))
        f(*args)

def call_global():
    i = datetime.datetime.now()
    print('%s: %s# gtags -i -f proj_file_list.in' % (i,os.getcwd()))

    result = subprocess.run(['tag_build.sh'], stderr=subprocess.DEVNULL)
    if result.returncode != 0:
        print('retudncode = %d, doing full tag bulid!!' % result.returncode)
        result = subprocess.run(['tag_build.sh', '-n'])
        if result.returncode != 0:
            print('new tag build failed rc=%d, aborting script' % result.returncode)
            sys.exit()

    print('ctags -R..')
    ctags_path = find_executable('ctags')
    subprocess.run([ctags_path, '-R'], stderr=subprocess.DEVNULL)
    print("Done.")

def handler(signum, frame):
    call_global()

import sys
print(sys.version, '\n')

signal.signal(signal.SIGUSR2,handler)
do_every(10*60,call_global)


# def hello(s):
#     print('hello {} ({:.4f})'.format(s,time.time()))
#     time.sleep(.3)

#do_every(1,hello,'foo')

