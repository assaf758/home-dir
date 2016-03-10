#!/bin/bash
#The caps-lock key serves as additional ctrl. no caps-lock functionality
setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option  
# setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option 'ctrl:nocaps', 'grp:shifts_toggle'
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
  printf "\nLayout set to qwerty:\n"
  setxkbmap -rules evdev -model logitech_base -layout 'us,il'  -option 'ctrl:nocaps', 'grp:shifts_toggle'
  setxkbmap -query
  ;;
qwerty-c)
  printf "\nLayout set to qwerty-c:\n"
  setxkbmap -rules evdev -model logitech_base -layout 'us,il' , 'grp:shifts_toggle'
  setxkbmap -query
  ;;
workman)
  printf "\nLayout set to workman:\n"
  setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant 'workman, ' -option 'ctrl:nocaps', 'grp:shifts_toggle'
  setxkbmap -query
  ;;
*)
  echo "Parameter value $1 is not supported"
  echo "Usage: ${0##*/} qwerty | workman"
  ;;
esac

xcape -e 'Control_L=Escape;Control_R=Control_R|O'
  # turn on stickykeys. don't let two keys pressed at the same time disable it.
  # turn on "latch lock", ie pressing a modifier key twice "locks" it on.
  # accessx: press shift 5 times to disable sticky behavior
  #xkbset accessx sticky -twokey latchlock
  # don't expire these settings. (run xkbset q exp for details.)
  #xkbset exp 5  =accessx =sticky =twokey =latchlock

