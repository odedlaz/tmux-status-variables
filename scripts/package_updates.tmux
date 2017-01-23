#!/bin/bash
echo "$(/usr/lib/update-notifier/apt-check 2>&1 > /dev/null)"
