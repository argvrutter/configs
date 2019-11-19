#!/bin/bash
sleep 10
conky -b -c ~/.conky/battery &
# conky -b -c ~/.conky/radial_graphs &
conky -b -c ~/.conky/date_time &
