#!/bin/bash

# Just a dirty script for lemonbar,

# main monitor
monitor=${1:-0}

# padding
herbstclient pad $monitor 24

# settings
RES="x24"
#FONT="Font\Awesome\5\Free:style=Regular:pizelsize=12"
#FONT="Font\Awesome\5\Free:style=Regular:pizelsize=10"
#FONT2="Font\Awesome\5\Free:style=Solid:pizelsize=10"
#FONT3="Font\Awesome\5\Brands:pizelsize=12"
#FONT="*-siji-medium-r-*-*-10-*-*-*-*-*-*-*"
#FONT4="Iosevka:style=Bold:pixelsize=14"
FONT="NotoSansDisplay\Nerd\Font:style=Bold:pixelsize=11"
#FONT="Hack\Nerd\Font:style=Bold:pixelsize=16"
#FONT="RobotoMono\Nerd\Font:style=Medium:pixelsize=16"
#FONT="DroidSansMono\Nerd\Font\Mono:style=Bold:pixelsize=12"
#FONT2="-*-cure.se-medium-r-*-*-11-*-*-*-*-*-*-*"
#FONT2="*-benis-lemon-medium-r-*-*-10-*-*-*-*-*-*-*"
#FONT2="Kochi\Gothic:pixelsize=16"
FONT2="mplus\Nerd\Font:style=bold:pixelsize=11"

BG="#272c37"
BA="#242629"
FG="#d0d6e0"
BLK="#434a5a"
RED="#b75962"
RED2="#bf616a"
YLW="#e3c383"
BLU="#7999b9"
GRA="#898989"
VLT="#ac86a5"

# icons
st="%{F$YLW}    %{F-}"
sm="%{F$RED}    %{F-}"
sv="%{F$BLU}    %{F-}"
sd="%{F$VLT}    %{F-}"

# functions
set -f
	
function uniq_linebuffered() {
    awk -W interactive '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

# events
{   
   # # now playing
   # while true ; do
   #     echo "mus $(deadbeef --nowplaying '%a  %t')"
   #     sleep 1 || break
   # done > >(uniq_linebuffered) &
   # mus_pid=$!

   # now playing
   mpc idleloop player | cat &
   mus_pid=$!

    # volume
    while true ; do
        echo "vol $(amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/')"
	sleep 1 || break
    done > >(uniq_linebuffered) &
    vol_pid=$!
    
    # date
    while true ; do
        date +'date_min %b %d %A %H:%M'
        sleep 1 || break
    done > >(uniq_linebuffered) &
    date_pid=$!

    # herbstluftwm
    herbstclient --idle

    # exiting; kill stray event-emitting processes
    kill $mus_pid $vol_pid $date_pid    
} 2> /dev/null | {
    TAGS=( $(herbstclient tag_status $monitor) )
    unset TAGS[${#TAGS[@]}]
    time=""
    song="nothing to see here"
    windowtitle="what have you done?"
    visible=true

        while true ; do
        echo -n "%{l}"
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#') # current tag
                    echo -n "%{B$RED}%{F$FG}"
                    ;;
                '+') # active on other monitor
                    echo -n "%{B$YLW}"
                    ;;
                ':')
                    echo -n "%{B-}%{F-}"
                    ;;
                '!') # urgent tag
                    echo -n "%{B$YLW}"
                    ;;
                *)
                    echo -n "%{B-}%{F-}"
                    ;;
            esac
            echo -n " ${i:1} %{B-}%{F-}"
        done
	
	# center window title
	echo -n "%{c}$st${windowtitle//^/^^}"
	
        # align right
        echo -n "%{r}"
        echo -n "$sm"
        echo -n "$song" %{F$YLW}"$song2"%{F-}
        echo -n "$sv"
        echo -n "$volume"
        echo -n "$sd"
        echo -n "$date "
        echo ""
	
        # wait for next event
        read line || break
        cmd=( $line ) 
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                TAGS=( $(herbstclient tag_status $monitor) )
                unset TAGS[${#TAGS[@]}]
                ;;
            #mus)
	    #    mus="${cmd[@]:1}"
	    #    ;;
            mpd_player|player)
                song="$(mpc -f %artist% current)"
                song2="$(mpc -f %title% current)"
                ;;
            vol)
                volume="${cmd[@]:1}"
                ;;
            date_min)
                date="${cmd[@]:1}"
                ;;
	    focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            quit_panel)
                exit
                ;;
            reload)
                exit
                ;;
        esac
    done
} 2> /dev/null | lemonbar -u 6 -g ${RES} -B ${BG} -F ${FG} -f ${FONT} -f ${FONT2} & $1
#lemonbar -u 6 -g ${RES} -B ${BG} -F ${FG} -f ${FONT} -f ${FONT2} -f ${FONT3} -f ${FONT4} -f ${FONT5} & $1
