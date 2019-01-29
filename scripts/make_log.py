#!/usr/bin/env python
import sys
import re
import subprocess
import os
from six.moves import input

build_matcher = re.compile('(?:^\[ {0,2}\d{1,3}\%\] |^(Scanning dependencies of target|Essential files are checked|Writing|Removing|running|--|make\[3\]: warning: jobserver unavailable:))')

while True:
    rows, columns = os.popen('stty size', 'r').read().split()
    print 'make_log.py: rows = {}\n'.format(rows)
    p = subprocess.Popen(
            'make -j 6',
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
    found_line_idx = sys.maxint 
    found_error = False
    for line_idx, line in enumerate(p.stdout):
        if found_error == True:
            if line_idx == found_line_idx + (int(rows) - 8):
                break
        else:
            match_line = build_matcher.search(line)
            if match_line is None:
                found_error = True
                print 'make_log.py: build detected as fail due to line: {}'.format(line)
                found_line_idx = line_idx
        print line,
    p.kill()
    if found_line_idx != sys.maxint:
        for row in xrange(int(rows) - (line_idx - found_line_idx) - 8 ):
            print
    if found_error == False:
        print '\n*** All good!\n'
    input('Press Enter to continue...')
