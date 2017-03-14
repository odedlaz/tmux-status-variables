#!/bin/bash
CURRENT_DIR=$(tmux show-option -gqv "@status_variables_dir")
source "$CURRENT_DIR/utils/tmux.sh"

DEBUG=$(get_tmux_option "@status_variables_debug" "false")

TEMP_DIR=$(dirname $(mktemp -u))

now() {
   echo "$(date +%s)"
}

log() {
   if [ "$DEBUG" != "true" ]; then
      return 0
   fi

   logger=$1
   message=$2

   if [ -z "$2" ]; then
      message=$1
      logger=""
   fi

   ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
   echo "$ts [$logger] - $message"  >> \
      "${TEMP_DIR}/.tmux/status_variables.log"
}
