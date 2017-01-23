#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DEFAULT_SCRIPTS_DIR="$CURRENT_DIR/scripts"
source "$CURRENT_DIR/utils/tmux.sh"

interpolate() {
   local file=$1
   local line=$2
   basename=$(basename $file)
   name="${basename%.*}"
   name_interpolation="\#{$name}"
   script_output="#($file)"
   echo "${line/$name_interpolation/$script_output}"
}

execute_scripts() {
   local output="$1"

   for file in $DEFAULT_SCRIPTS_DIR/*.tmux; do
      output=$(interpolate "$file" "$output")
   done

   local user_scripts_dir=$(get_tmux_option "@user_scripts_dir" "")
   if [ -d "$user_scripts_dir" ]; then
      for file in $user_scripts_dir/*.tmux; do
         output=$(interpolate "$file" "$output")
      done
   fi

   echo $output
}

set_tmux_option "@status_variables_dir" "$CURRENT_DIR"
update_tmux_option execute_scripts "status-left"
update_tmux_option execute_scripts "status-right"
