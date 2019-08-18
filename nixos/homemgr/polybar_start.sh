#!/usr/bin/env bash

for monitor in $(xrandr --current | egrep '\w* conn' | awk '{print $1}')
do
    polybar "$monitor" &
done
