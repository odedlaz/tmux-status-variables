#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/tmux_utils.sh"

TEMP_DIR=$(dirname $(mktemp -u))
BASE_DIR="$TEMP_DIR/.tmux"

CACHE_TS_FILENAME="$BASE_DIR/status_variables.ts"
CACHE_FILENAME="$BASE_DIR/$(basename $0).cache"

now() {
   echo "$(date +%s)"
}

get_status_interval() {
   echo $(get_tmux_option "status-interval" "")
}

get_cache_timestamp () {
   if [ ! -f "$CACHE_TS_FILENAME" ]; then
      echo "0" > $CACHE_TS_FILENAME
   fi
   echo "$(cat $CACHE_TS_FILENAME)"
}

cache_value() {
   val="$1"
   echo "$(now)" > $CACHE_TS_FILENAME
   echo "$val" > $CACHE_FILENAME
}

cached_value() {
   fn="$1"
   timedelta="$(( $(now) - $(get_cache_timestamp) ))"
   if [ "$timedelta" -lt "$(get_status_interval)" ]; then
      cat $CACHE_FILENAME
      exit 0
   fi

   return_value="$($fn)"
   cache_value "$return_value"
   echo $return_value
}

mkdir -p "$BASE_DIR"
