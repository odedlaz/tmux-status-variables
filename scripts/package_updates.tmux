#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache_utils.sh"

get_package_updates() {
   echo "$(/usr/lib/update-notifier/apt-check 2>&1 > /dev/null)"
}

cached_value get_package_updates
