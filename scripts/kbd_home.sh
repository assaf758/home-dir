#!/bin/bash
#The caps-lock key serves as additional ctrl. no caps-lock functionality
setxkbmap -rules evdev -model microsoft4000 -layout 'us,il' -variant '' -option  
setxkbmap -rules evdev -model microsoft4000 -layout 'us,il' -variant '' -option 'ctrl:nocaps' 'grp:alt_shift_toggle' 
setxkbmap -query
# note that xmodmap seems to break the "esc" funciotnality in slickedit

#xmodmap ~/.Xmodmap


