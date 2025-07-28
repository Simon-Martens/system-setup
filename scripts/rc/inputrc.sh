# Configure readline settings using bind commands
bind 'set meta-flag on'
bind 'set input-meta on'
bind 'set output-meta on'
bind 'set convert-meta off'
bind 'set completion-ignore-case on'
bind 'set completion-prefix-display-length 2'
bind 'set show-all-if-ambiguous on'
bind 'set show-all-if-unmodified on'

# Arrow keys match what you've typed so far against your command history
# bind '"\e[A": history-search-backward'
# bind '"\e[B": history-search-forward'
# bind '"\e[C": forward-char'
# bind '"\e[D": backward-char'

# Immediately add a trailing slash when autocompleting symlinks to directories
bind 'set mark-symlinked-directories on'

# Show all autocomplete results at once
bind 'set page-completions off'

# If there are more than 200 possible completions for a word, ask to show them all
bind 'set completion-query-items 200'

# Show extra file information when completing, like `ls -F` does
bind 'set visible-stats on'

# Be more intelligent when autocompleting by also looking at the text after
# the cursor. For example, when the current line is "cd ~/src/mozil", and
# the cursor is on the "z", pressing Tab will not autocomplete it to "cd
# ~/src/mozillail", but to "cd ~/src/mozilla". (This is supported by the
# Readline used by Bash 4.)
bind 'set skip-completed-text on'

# Coloring for Bash 4 tab completions.
bind 'set colored-stats on'
