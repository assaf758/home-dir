#!/bin/bash
#The caps-lock key serves as additional ctrl. no caps-lock functionality
setxkbmap -rules evdev -model microsoft4000 -layout us -option  
setxkbmap -query
# note that xmodmap seems to break the "esc" funciotnality in slickedit

#xmodmap ~/.Xmodmap


