#!/bin/bash

total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
avail=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
used=$((total - avail))
pct=$((used * 100 / total))

if [ $pct -lt 50 ]; then
  color="#50fa7b"
elif [ $pct -lt 75 ]; then
  color="#f1fa8c"
elif [ $pct -lt 90 ]; then
  color="#ffb86c"
else
  color="#ff5555"
fi

echo "<span color=\"$color\">$((used/1024))M/$((total/1024))M</span>"
