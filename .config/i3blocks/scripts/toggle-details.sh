#!/bin/bash
case $BLOCK_NAME in
    cpu_usage)
        notify-send "CPU Details" "$(top -bn1 | head -20)"
        ;;
    memory)
        notify-send "Memory Details" "$(free -h)"
        ;;
    disk)
        notify-send "Disk Usage" "$(df -h)"
        ;;
    *)
        ;;
esac
