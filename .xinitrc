
#!/bin/sh

#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)
#
ssh_settings

export GTK2_RC_FILES="$HOME/.gtkrc-2.0"


DEFAULT_SESSION=xfce4-session
case $1 in
  xfce) exec dbus-launch xfce4-session ;;
  wingo) 
	 exec conky | dzen2 -dock &
	 exec termite &
     exec --no-startup-id xfsettingsd --sm-client-disable &
     exec wingo 
  ;;
  *) exec dbus-launch  $DEFAULT_SESSION ;;
esac
