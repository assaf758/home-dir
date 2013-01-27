#!/bin/bash

svn status $1 |grep -e "^C\|^M\|^ M\|^A\|^ A\|^D\|^ D"
