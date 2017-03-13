#!/bin/bash
source "$(tmux show-option -gqv "@status_variables_dir")/utils/sdk.sh"

apt_on_cache_miss() {
   echo "$(/usr/lib/update-notifier/apt-check 2>&1 > /dev/null)"
}

dnf_on_cache_miss() {
   log "dnf" "fetching all available updates"
   all_updates="$(dnf -q updateinfo list 2>/dev/null | wc -l)"
   log "dnf" "there are $all_updates updates"

   log "dnf" "fetching security updates"
   security_updates="$(dnf -q updateinfo list security 2> /dev/null | wc -l)"
   log "dnf" "there are $security_updates security updates"

   non_security_updates=$(($all_updates - $security_updates))
   log "dnf" "there are $non_security_updates non security updates"
   printf "%s;%s\n" $non_security_updates $security_updates
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
