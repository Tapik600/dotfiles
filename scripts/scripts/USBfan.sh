#!/bin/bash

cpu=$(</sys/class/thermal/thermal_zone0/temp)
on_temp=45000
off_temp=30000

port_state=$(sudo uhubctl -l 1-1 | tail -1 | awk '{ print $NF }')

if [ $cpu -gt $on_temp ]; then
    if [ $port_state == "off" ]; then
        sudo uhubctl -l 1-1 -a 1 >/dev/null
        printf "%-6.4d %-10s %-13s $(date +"%a %F %H:%M")\n" $cpu "Overtemp" "[usbfan ON]"
    fi
elif [ $off_temp -gt $cpu ]; then
    if [ $port_state == "power" ]; then
        sudo uhubctl -l 1-1 -a 0 >/dev/null
        printf "%-6.4d %-10s %-13s $(date +"%a %F %H:%M")\n" $cpu "Undertemp" "[usbfan OFF]"
    fi
fi
