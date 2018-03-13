#!/bin/bash
sleep 10
conky -b -c ~/configs/conky/battery &
conky -b -c ~/configs/conky/radial_graphs &
conky -b -c ~/configs/conky/Red_Rings &
