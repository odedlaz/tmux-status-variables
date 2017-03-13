#!/bin/bash
CURRENT_DIR=$(tmux show-option -gqv "@status_variables_dir")
source "$CURRENT_DIR/utils/tmux.sh"
source "$CURRENT_DIR/utils/misc.sh"

TEMP_DIR=$(dirname $(mktemp -u))
BASE_DIR="$TEMP_DIR/.tmux"

CACHE_TS_FILENAME="$BASE_DIR/status_variables.ts"
CACHE_FILENAME="$BASE_DIR/$(basename $0).cache"

get_cache_timestamp () {
   if [ ! -f "$CACHE_TS_FILENAME" ]; then
      echo 0 > $CACHE_TS_FILENAME
   fi
   echo "$(cat $CACHE_TS_FILENAME)"
}

cache_value() {
   data="$1"
   echo "$(now)" > $CACHE_TS_FILENAME
   echo "$data" > $CACHE_FILENAME
}

get_cached_value() {
   on_cache_miss_fn="$1"
   if [  -z "$on_cache_miss_fn" ]; then
      echo "cache miss delegate has to be set"
      return 1
   fi

   # grab the cache invalidation interval
   # of the plugin who's asking for it
   invalidate_interval=$(get_tmux_option \
      "@$(basename $0 .tmux)_invalidate_cache_interval" \
      "$(get_status_interval)")

   timedelta="$(( $(now) - $(get_cache_timestamp) ))"

   # create an empty cached file if non exists
   if [ ! -f $CACHE_FILENAME ]; then
      touch $CACHE_FILENAME
   fi

   if [ "$timedelta" -lt "$invalidate_interval" ]; then
      cat $CACHE_FILENAME
      return 0
   fi

   return_value="$($on_cache_miss_fn)"
   cache_value "$return_value"
   echo $return_value
}

mkdir -p "$BASE_DIR"
