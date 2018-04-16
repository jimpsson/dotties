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

# URXvt fuckage
[ -f ~/.Xresources ] \
  && xrdb -merge -I$HOME ~/.Xresources

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
   #sxhkd &
   sxhkd -c ~/.config/sxhkd/sxhkdrc \
            ~/.config/sxhkd/sxhkdrc.herb &
   redshift -l 64:25 -b 0.8:0.8 &> /dev/null &
   nitrogen --restore
}

autokill() {
   killall sxhkd
   killall lemonbar
   killall redshift
}

# EXEcute
autostart &
#export XDG_CURRENT_DESKTOP=Budgie:GNOME
#exec ck-launch-session budgie-desktop
exec ck-launch-session herbstluftwm
autokill; sleep 1
