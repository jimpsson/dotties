#!/bin/dash
# This little script outputs
# your current virtual desktop.
# Quite dirty, makes innocent
# souls to cry, you've been warned.

# settings
#RES="x18+1280x"
RES="240x24+2120+20"
FONT="*-siji-medium-r-*-*-10-*-*-*-*-*-*-*"
FONT2="-*-cure.se-medium-r-*-*-11-*-*-*-*-*-*-*"
BG="#1D1F21"
FG="#A8A8A8"
RED="#834F48"

# functions
work(){
	NUMB=$(xprop -root -notype _NET_CURRENT_DESKTOP | cut -d= -f2);
		case "$NUMB" in
			" 0")
			        WORKSPACE="%{F$RED}%{F-}     ";;
			" 1")
				WORKSPACE=" %{F$RED}%{F-}    ";;
			" 2")
				WORKSPACE="  %{F$RED}%{F-}   ";;
			" 3")
				WORKSPACE="   %{F$RED}%{F-}  ";;
			" 4")
				WORKSPACE="    %{F$RED}%{F-} ";;
			" 5")
				WORKSPACE="     %{F$RED}%{F-}";;

		esac
	echo "$WORKSPACE"
}

# output
while :; do
   BUF=''
   BUF="${BUF}%{c}"
   BUF="${BUF}$(work) "
   echo "${BUF}"
sleep 2s
done 2> /dev/null | lemonbar -d -b -g ${RES} -u 3 -B ${BG} -d -F ${FG} -f ${FONT} -f ${FONT2} & $1
