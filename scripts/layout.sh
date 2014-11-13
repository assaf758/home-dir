#!/bin/bash

setxkbmap -print | grep xkb_symbols | awk '{print $4}' | awk -F"+" '{print $2}'
