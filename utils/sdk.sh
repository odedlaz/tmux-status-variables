#!/bin/bash
CURRENT_DIR=$(tmux show-option -gqv "@status_variables_dir")

source "$CURRENT_DIR/utils/tmux.sh"
source "$CURRENT_DIR/utils/cache.sh"
source "$CURRENT_DIR/utils/misc.sh"
