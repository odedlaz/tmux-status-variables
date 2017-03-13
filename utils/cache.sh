#!/bin/bash
CURRENT_DIR=$(tmux show-option -gqv "@status_variables_dir")
source "$CURRENT_DIR/utils/tmux.sh"
source "$CURRENT_DIR/utils/misc.sh"

TEMP_DIR=$(dirname $(mktemp -u))
BASE_DIR="$TEMP_DIR/.tmux"

get_cache_filename() {
   echo "$BASE_DIR/${1}.cache"
}

get_cache_timestamp_filename() {
   echo "$BASE_DIR/${1}.ts"
}

get_cache_timestamp () {
   filename="$(get_cache_timestamp_filename $1)"
   if [ ! -f "$filename" ]; then
      echo 0 > $filename
   fi
   echo "$(cat $filename)"
}

cache_value() {
   echo "$(now)" > $(get_cache_timestamp_filename $1)
   echo "$2" > $(get_cache_filename $1)
}

get_cached_value() {
   plugin="$(basename $0 .tmux)"
   log "cache" "getting value for '$plugin'"

   on_cache_miss_fn="$1"
   if [  -z "$on_cache_miss_fn" ]; then
      log "cache" "cache miss delegate has to be set"
      return 1
   fi

   # grab the cache invalidation interval
   # of the plugin who's asking for it
   invalidate_interval=$(get_tmux_option \
      "@${plugin}_invalidate_cache_interval" \
      "$(get_status_interval)")
   log "cache" "'$plugin' value invalidates every $invalidate_interval secs"

   timedelta="$(( $(now) - $(get_cache_timestamp ${plugin}) ))"
   log "cache" "'$plugin' was last updated $timedelta secs ago"

   # create an empty cached file if non exists
   cache_filename=$(get_cache_filename $plugin)
   if [ ! -f "$cache_filename" ]; then
      touch "$cache_filename"
   fi

   if [ "$timedelta" -lt "$invalidate_interval" ]; then
      left=$(($invalidate_interval - $timedelta))
      log "cache" "'$plugin' cache is still valid for the next $left secs"
      cat $cache_filename
      return 0
   fi

   log "cache" "'$plugin' cache item invalidated"
   return_value="$($on_cache_miss_fn)"
   cache_value "$plugin" "$return_value"
   log "cache" "'$plugin' return value cached"
   echo $return_value
}

mkdir -p "$BASE_DIR"
