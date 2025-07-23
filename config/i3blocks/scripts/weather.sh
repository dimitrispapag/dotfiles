#!/bin/bash
# Weather script for i3blocks

# Get weather for Mannheim (your location)
weather=$(curl -s "http://wttr.in/Mannheim?format=%t" 2>/dev/null)

if [ -n "$weather" ] && [ "$weather" != "" ]; then
    echo "<span color='#f8f8f2'>$weather</span>"
else
    echo "<span color='#6272a4'>N/A</span>"
fi
