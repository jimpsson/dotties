#!/bin/dash
# dash is faster
# motherfucker.

# settings
BG="#1D1F21"
FG="#A8A8A8"
#RES="160x24+3016+20"
RES="160x24+1740+20"
BRD="2"
BRDC="#303030"
FONT="-*-cure.se-medium-r-*-*-11-*-*-*-*-*-*-*" 

# clock
while :; do
	echo "%{c}$(date "+%b %d %A %H:%M")%{c}"
	sleep 50s
done |

lemonbar -b -g "${RES}" -r "${BRD}" -R "${BRDC}" -f "${FONT}" -B "${BG}" -F "${FG}"

