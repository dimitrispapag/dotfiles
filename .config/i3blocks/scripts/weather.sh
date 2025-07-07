#!/bin/bash

weather=$(curl -s 'wttr.in/?format=%C+%t')

if [ -z "$weather" ]; then
  echo '<span color="#ff5555">N/A</span>'
else
  echo "<span color='#50fa7b'>$weather</span>"
fi

