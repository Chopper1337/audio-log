#!/bin/bash

today=$(date +%Y%m%d_%H%M%S)
mkdir -p $today
cd $today || exit

arecord -f cd -t wav "$today.wav"
