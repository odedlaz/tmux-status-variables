# tmux-status-variables
Tmux plugin that eases the usage of scripts in tmux status line

## Usage

Each `*.tmux` scripts in the `scripts directory` and `@user_scripts_dir` is loaded.  
the name of the script is the name of the variable that'll be used in the status line.

for example, the `free_mem.tmux` script echos the amount of free memory.  
to add it to the left status, just write: `set -g status-left "#{free_mem}"`


### Set Options

Set the following options in your `.tmux.conf`.

You can add an additional scripts dir by setting the following:

```
set -g @user_scripts_dir "/path/to/scripts/dir"
```

otherwise, only the default script directory will be used.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

set -g @plugin 'tmux-plugins/tmux-status-variables'

Hit `prefix + I` to fetch the plugin and source it.

### Manual Installation

Clone the repo:

$ git clone https://github.com/odedlaz/tmux-status-variables ~/clone/path

Add this line to the bottom of `.tmux.conf`:

run-shell ~/clone/path/tmux_status_variables.tmux

Reload TMUX environment (type this in terminal)

   $ tmux source-file ~/.tmux.conf

### Special Credit
This plugin is heavily based on [tmux-net-speed](https://github.com/beeryardtech/tmux-net-speed) by [beeryardtech](https://github.com/beeryardtech).

### License

[MIT](LICENSE)
