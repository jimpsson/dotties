#!/bin/bash
#          ██          ██   ██                 
#         ░░          ░░   ░██                 
#  ██   ██ ██ ███████  ██ ██████ ██████  █████ 
# ░░██ ██ ░██░░██░░░██░██░░░██░ ░░██░░█ ██░░░██
#  ░░███  ░██ ░██  ░██░██  ░██   ░██ ░ ░██  ░░ 
#   ██░██ ░██ ░██  ░██░██  ░██   ░██   ░██   ██
#  ██ ░░██░██ ███  ░██░██  ░░██ ░███   ░░█████ 
# ░░   ░░ ░░ ░░░   ░░ ░░    ░░  ░░░     ░░░░░  
# destroy everything!

# don't even ask me 
if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
   done
   unset f
fi

# magic
setxkbmap fi
xset s off
xset -dpms
xset r rate 200 30
xsetroot -cursor_name left_ptr
setxkbmap -option terminate:ctrl_alt_bksp

# automagic
autostart() {
   urxvtd -q -f -o
   sxhkd -c ~/.config/sxhkd/sxhkdrc \
            ~/.config/sxhkd/sxhkdrc.herb &
   #sxhkd &
   redshift -l 64:25 -b 0.8:0.8 &> /dev/null &
   nitrogen --restore &
   xmodmap .Xmodmap
}

autokill() {
   killall sxhkd
   killall lemonbar
   killall redshift
}

# EXEcute
autostart &
mons -s &
exec herbstluftwm
