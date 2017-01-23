#!/bin/sh
free -h | awk  '/Mem:/{print $7}'

