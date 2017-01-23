#!/bin/bash
CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/cache_utils.sh"

get_external_ip_address() {
   echo "$(curl -s https://api.ipify.org)"
}

cached_value get_external_ip_address
