#!/bin/sh
nohup /usr/bin/Xvfb :99 -screen 0 1344x768x24 -noreset -ac -nolisten tcp > /dev/null 2>&1 &
