#!/bin/bash

update_tmux_option() {
   interpolate_fn=$1
   option="$2"
   local option_value=$(get_tmux_option "$option")
   local new_option_value=$($interpolate_fn "$option_value")
   set_tmux_option "$option" "$new_option_value"
}

get_tmux_option() {
   local option=$1
   local default_value=$2
   local option_value="$(tmux show-option -gqv "$option")"

   if [[ -z "$option_value" ]]; then
      echo "$default_value"
   else
      echo "$option_value"
   fi
}

set_tmux_option() {
   local option=$1
   local value=$2
   tmux set-option -gq "$option" "$value"
}

get_status_interval() {
   echo $(get_tmux_option "status-interval" "")
}

