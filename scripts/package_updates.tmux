#!/bin/bash
CURRENT_DIR=$(tmux show-option -gqv "@status_variables_dir")
source "$CURRENT_DIR/utils/sdk.sh"

on_cache_miss() {
   echo "$(/usr/lib/update-notifier/apt-check 2>&1 > /dev/null)"
}

echo "$(get_cached_value on_cache_miss)"
