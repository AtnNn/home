#!/bin/bash

. ~/.session/environment

export BROWSER=/usr/bin/firefox

# X configuration
xsetroot -solid white
xrdb < ~/.Xresources
setxkbmap -option ctrl:nocaps

# background software
redshift -l 37:-122 &
eval `ssh-agent`
eval `gpg-agent --daemon`
emacs --daemon &
unclutter &

(sleep 1; xsetroot -solid black ) &

# Xmonad
export _JAVA_AWT_WM_NONREPARENTING=1
exec xmonad
