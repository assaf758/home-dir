#!/bin/bash
#The caps-lock key serves as additional ctrl. no caps-lock functionality
setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option  
setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option 'ctrl:nocaps', 'grp:shifts_toggle'
xmodmap -e "clear lock"
# note that xmodmap seems to break the "esc" funciotnality in slickedit

#assign altgr to alt_r
#xmodmap -e "keycode 108 = Alt_R"

# Select keyboard layout
case "$1" in 
"") 
  echo "Usage: ${0##*/} qwerty | workman"
  ;;
qwerty)
  ;;
workman)
#  setxkbmap -layout 'us,il' -variant 'workman,'
setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant 'workman, ' -option 'ctrl:nocaps', 'grp:shifts_toggle'

  ;;
*)
  echo "Parameter value $1 is not supported"
  echo "Usage: ${0##*/} qwerty | workman"
  ;;
esac

setxkbmap -query

  # turn on stickykeys. don't let two keys pressed at the same time disable it.
  # turn on "latch lock", ie pressing a modifier key twice "locks" it on.
  # accessx: press shift 5 times to disable sticky behavior
  #xkbset accessx sticky -twokey latchlock
  # don't expire these settings. (run xkbset q exp for details.)
  #xkbset exp 5  =accessx =sticky =twokey =latchlock

