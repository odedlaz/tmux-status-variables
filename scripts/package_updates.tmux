#!/bin/bash
source "$(tmux show-option -gqv "@status_variables_dir")/utils/sdk.sh"

apt_on_cache_miss() {
   echo "$(/usr/lib/update-notifier/apt-check 2>&1 > /dev/null)"
}

dnf_on_cache_miss() {
   log "dnf" "fetching all available updates"
   readarray -t all <<< "$(dnf -q check-update)"
   sec=$(printf '%s\n' "${all[@]}" | awk NF | grep -c "security")
   not_sec=$(printf '%s\n' "${all[@]}" | awk NF | grep -vc "security")

   log "dnf" "there are ${#all[@]} updates"
   log "dnf" "there are $sec security updates"
   log "dnf" "there are $not_sec non security updates"
   printf "%s;%s\n" $not_sec $sec
}

on_cache_miss() {
   if which apt &> /dev/null; then
      apt_on_cache_miss
      return 0
   fi

   if which dnf &> /dev/null; then
      dnf_on_cache_miss
      return 0
   fi

   echo "os not supported"
   return 1
}

echo "$(get_cached_value on_cache_miss)"
