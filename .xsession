#!/bin/bash

# X configuration
xsetroot -solid white
xrdb < ~/.Xresources
setxkbmap -option ctrl:nocaps

# background software
redshift -l 37:-122 &
eval `ssh-agent`
eval `gpg-agent --daemon`
emacs --daemon

(sleep 1; xsetroot -solid black ) &

. ~/.session/environment

# Xmonad
export _JAVA_AWT_WM_NONREPARENTING=1
exec xmonad
