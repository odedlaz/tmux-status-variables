# tmux-status-variables
Tmux plugin that eases the usage of scripts in tmux status line

### Usage

Simply add the plugin name to `status-left` or `status-right` and `tmux-status-variables` will do the rest.  

#### Example
  
  Add the following to your `tmux.conf`, to show the amount of free memory:  
  `set -g status-left "#{free_mem}"`


### Plugins

| Name              | Script           | Explanation                                                                        |
|:------------------|:-----------------|:-----------------------------------------------------------------------------------|
| External IP       | external_ip      | Show your external internet ip address (using [ipify.org](https://www.ipify.org))  |
| Free Memory       | free_mem         | Show how much free memory is available                                             |
| Package Updates   | package_updates  | Show if there are any package updates (updates;security-updates)                   |
| System Uptime     | uptime           | Show the uptime of the system                                                      |

### Set Options

Set the following options in your `.tmux.conf`.

You can add an additional scripts dir by setting the following:

```
set -g @user_scripts_dir "/path/to/scripts/dir"
```

otherwise, only the default script directory will be used.

### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

set -g @plugin 'odedlaz/tmux-status-variables'

Hit `prefix + I` to fetch the plugin and source it.

### Manual Installation

Clone the repo:

$ git clone https://github.com/odedlaz/tmux-status-variables /a/clone/path

Add this line to the bottom of `.tmux.conf`:

run-shell /a/clone/path/tmux_status_variables.tmux

Reload TMUX environment (type this in terminal)

   $ tmux source-file ~/.tmux.conf

### How does it work?

Each `*.tmux` scripts in the `scripts directory` and `@user_scripts_dir` is loaded.  
the name of the script is the name of the variable that'll be used in the status line.

for example, the `free_mem.tmux` script echos the amount of free memory.  
to add it to the left status, just write: `set -g status-left "#{free_mem}"`

### Plugin skeleton

A regular plugin only needs to have execution priviledges.
For instance, lets look at this 'hello world' plugin:

```bash
#!/bin/bash
echo "hello world!"
```

If 'hello world' takes a lot of time, we might want to cache the result.   
Results are cached for `status-interval` seoconds. lets look at the following plugin:

```bash
#!/bin/bash
PLUGIN_DIR=$(tmux show-option -gqv "@status_variables_dir")
source "$PLUGIN_DIR/utils/sdk.sh"

on_cache_miss() {
   echo "hello world!"
   sleep 1
}

echo "$(get_cached_value on_cache_miss)"
```

Now, `on_cache_miss` will run only when `status-interval` seconds have passed.  
Every call in between will return the cached result!

This is important because tmux might refreshe the status line when redrawing the pane.  
Every time you press <Enter> or create a new pane, the status line is refreshed which causes many script calls.

### Special Credit
This plugin is heavily based on [tmux-net-speed](https://github.com/beeryardtech/tmux-net-speed) by [beeryardtech](https://github.com/beeryardtech).

### License

[MIT](LICENSE)
