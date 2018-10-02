#!/usr/bin/env python
import sys
import re
import subprocess
import os
from six.moves import input

error_matcher = re.compile('(?:In function|In file included)')

while True:
    p = subprocess.Popen(
            'make -j 6',
            shell=True,
            stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT)

    found_error = False
    for line_idx, line in enumerate(p.stdout):
        if found_error == True:
            if line_idx == found_line + 40:
                break
        match_line = error_matcher.match(line)
        if match_line is not None:
            found_error = True
            found_line = line_idx
        print line,
    p.kill()
    if found_error == True:
        input('Press Enter to continue...')
    else:
        print 'All good'
        break
