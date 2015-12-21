#!/bin/bash

. ~/.session/environment

export BROWSER=/usr/bin/firefox
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus

# X configuration
xsetroot -solid white
xrdb < ~/.Xresources
setxkbmap -option ctrl:nocaps

# background software
redshift -l 35:-80 &
eval `ssh-agent`
# eval `gpg-agent --daemon`
emacs --daemon &
unclutter &
ibus-daemon --daemonize --xim
copyq &

# power saving
# echo 50 > /sys/class/backlight/acpi_video0/brightness

(sleep 1; xsetroot -solid black ) &

# Xmonad
export _JAVA_AWT_WM_NONREPARENTING=1
exec xmonad
