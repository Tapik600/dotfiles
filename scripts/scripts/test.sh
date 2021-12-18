#!/bin/bash

cpu=$(</sys/class/thermal/thermal_zone0/temp)
on_temp=50000
off_temp=35000

printf "%-6.4d Overtemp [usbfan ON] - $(date -R) \n" $cpu

if [ $on_temp -gt $cpu ]; then
    echo "OK"
else
        echo "else"
    if [ $cpu -gt $off_temp ]; then
        echo "Not"
    fi
fi
