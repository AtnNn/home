#!/bin/bash

# . ~/.bashrc

# X configuration
xsetroot -solid white
xrdb < ~/.Xresources

# backgroud software
redshift -l 37:-122 &
eval `ssh-agent`
eval `gpg-agent --daemon`

emacs --daemon &

(sleep 1; xsetroot -solid black ) &

# Xmonad
export _JAVA_AWT_WM_NONREPARENTING=1
exec xmonad

#exec openbox
