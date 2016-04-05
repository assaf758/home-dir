#!/bin/bash

#The caps-lock key serves as additional ctrl. no caps-lock functionality
# setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant '' -option
# xmodmap -e "clear lock"

# note that xmodmap seems to break the "esc" funciotnality in slickedit

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
  setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant 'workman, ' -option 'shift:both_capslock', 'grp_led:scroll','caps:ctrl_modifier ', 'grp:sclk_toggle '
  xcape -e 'Control_L=Escape;Control_R=Control_R|O'
  # see man xkeyboard-config for complete description
  # setxkbmap -rules evdev -model logitech_base -layout 'us,il' -variant 'workman, ' -option 'ctrl:nocaps', 'grp:shifts_toggle'
  setxkbmap -query
  ;;
*)
  echo "Parameter value $1 is not supported"
  echo "Usage: ${0##*/} qwerty | workman"
  ;;
esac

