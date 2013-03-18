#!/bin/bash

export LANG=ru_RU.UTF-8

# quick hack for setting up environment
. ~/.bashrc

# X configuration
xsetroot -solid white
xrdb < ~/.Xresources

# backgroud software
redshift -l 37:-122 &
eval `ssh-agent`
eval `gpg-agent --daemon`

# Xmonad
export _JAVA_AWT_WM_NONREPARENTING=1
(sleep 1; xsetroot -solid black ) &
exec xmonad
