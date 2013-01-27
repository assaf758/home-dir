#!/bin/sh
svn status $1 |grep -e "^C\|^M\|^ M\|^A\|^ A\|^D\|^ D"|sed 's@ + @@'|exediff-filter.sh|gawk '{print "svn diff -x -p " $1}'|sh
