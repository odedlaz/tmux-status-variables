#!/bin/bash
free -h | awk  '/Mem:/{print $7}'
