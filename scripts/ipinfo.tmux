#!/bin/bash
source "$(tmux show-option -gqv "@status_variables_dir")/utils/sdk.sh"

# use any of the following fields to set the format the ipinfo format
# for example: tmux set-option -g @ipinfo_format "#ip (#asn-#isp)"
ipinfo_format=$(get_tmux_option "@ipinfo_format" "#ip")
fields=("ip" "hostname" "city" "region" "country" "loc" "isp" "asn");

get_isp() {
   echo "$1" | jq -r .org | cut -d' ' -f2-
}

get_asn() {
   echo "$1" | jq -r .org | cut -d' ' -f1
}

on_cache_miss() {
   log "ipinfo" "getting fresh data from ipinfo.io"
   data="$(curl -s ipinfo.io/json)"
   log "ipinfo" "$data"

   ipinfo=$ipinfo_format
   for field in ${fields[@]}; do
      get_field_fn="get_$field"

      if declare -f $get_field_fn > /dev/null; then
         value=$($get_field_fn "$data")
      else
         value=$(echo $data | jq -r .$field)
      fi

      ipinfo=${ipinfo/\#$field/$value}
   done

   echo $ipinfo
}

if ! which jq &> /dev/null; then
   log "ipinfo" "jq is not installed"
   exit 1
fi

echo "$(get_cached_value on_cache_miss)"
