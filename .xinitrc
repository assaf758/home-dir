#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# [[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
xrdb -merge ~/.Xresources

# window-manager must be last line in this script
# exec gnome-session
# exec startkde
# ...or the Window Manager of your choice
exec startxfce4
#exec dwm

