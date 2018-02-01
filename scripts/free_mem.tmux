#!/bin/bash
free_kb=$(grep MemAvailable /proc/meminfo | grep -oh "[0-9]\+")
printf "%sG" $((($free_kb)/1024/1024))
