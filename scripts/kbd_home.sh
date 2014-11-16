#!/bin/bash
#The caps-lock key serves as additional ctrl. no caps-lock functionality
setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option  
setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option 'ctrl:nocaps', 'grp:shifts_toggle'
xmodmap -e "clear lock"
setxkbmap -query
# note that xmodmap seems to break the "esc" funciotnality in slickedit

#assign altgr to alt_r
xmodmap -e "keycode 108 = Alt_R"

# Select keyboard layout
case "$1" in 
"") 
  echo "Usage: ${0##*/} qwerty | workman"
  ;;
qwerty)
  ;;
workman)
  setxkbmap -layout 'us,il' -variant 'workman,'
  ;;
*)
  echo "Parameter value $1 is not supported"
  echo "Usage: ${0##*/} qwerty | workman"
  ;;
esac

