#!/usr/bin/env python
import sys
import re
import subprocess
import os
from six.moves import input

error_matcher = re.compile('(?:In function|In file included)')

while True:
    rows, columns = os.popen('stty size', 'r').read().split()
    p = subprocess.Popen(
            'make -j 6',
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)
    found_line_idx = sys.maxint 
    found_error = False
    for line_idx, line in enumerate(p.stdout):
        if found_error == True:
            if line_idx == found_line_idx + 40:
                break
        else:
            match_line = error_matcher.search(line)
            if match_line is not None:
                found_error = True
                found_line_idx = line_idx
        print line,
    p.kill()
    if found_line_idx != sys.maxint:
        for row in xrange(int(rows) - (line_idx - found_line_idx) - 3 ):
            print
    if found_error == False:
        print 'All good'
    input('Press Enter to continue...')
