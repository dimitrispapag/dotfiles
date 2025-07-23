#!/bin/bash
# Memory script for i3blocks

mem_used=$(free -h | awk '/^Mem:/ {print $3}')
mem_total=$(free -h | awk '/^Mem:/ {print $2}')
mem_percent=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100.0}')

if [ "$mem_percent" -lt 50 ]; then
    color="#50fa7b"
elif [ "$mem_percent" -lt 75 ]; then
    color="#f1fa8c"
elif [ "$mem_percent" -lt 90 ]; then
    color="#ffb86c"
else
    color="#ff5555"
fi

echo "<span color='$color'>${mem_used}/${mem_total}</span>"
