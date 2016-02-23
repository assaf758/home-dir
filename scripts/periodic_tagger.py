import time
import subprocess
import os
import datetime

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

def call_global(s):
    i = datetime.datetime.now()
    print('%s: %s# global -u' % (i,os.getcwd()))
    subprocess.call(['global','-u'])
    print("Done.")

do_every(20*60,call_global,'x')


# def hello(s):
#     print('hello {} ({:.4f})'.format(s,time.time()))
#     time.sleep(.3)

#do_every(1,hello,'foo')

