#!/bin/bash
ps -eo pid,ppid,comm | grep "1 nginx" | awk '{print $1}'
