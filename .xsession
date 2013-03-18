docker&

export XMODIFIER="@im=SCIM"
export XMODIFIERS="@im=SCIM"
export GTK_IM_MODULE="scim"
export XIM_PROGRAM="scim -d"
export QT_IM_MODULE="scim"
export ALTERNATIVE_EDITOR=emacs
scim -d

#dzen
#/home/atnnn/bin/dzen-script | dzen2 -ta r &

(while true; do kiba-dock; sleep 10; done)&

# Set background
eval `cat $HOME/.fehbg` &

#xscreensaver&

# Keyboard Config
lineakd&

# Window manager
compiz-manager&
#openbox&
#xmonad&
#waimea&
WMPID=$!

# Dockapps
#docker&
#sleep 2
#wmix&

# gmpc
gmpc&

# no bell
xset b 0

# gpg-agent
eval `gpg-agent --daemon --use-standard-socket`

# hide mouse when inactive
unclutter &

xterm -rv +cr orange &

# system tray
# stalonetray -i 10 --grow-gravity E --geometry 12x1+-2+-2 --skip-taskbar &

# Wait for window manager to stop
wait $WMPID
