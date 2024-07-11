#!/bin/sh

alias cp="cp -i"                                                # Confirm before overwriting something
alias mv='mv -i'                                                # Confirm before moving/overwriting something
alias rm='rm -i'                                                # Confirm before removing something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias ls='ls $LS_OPTIONS'
alias zsh-update-plugins="find "$ZDOTDIR/plugins" -type d -exec test -e '{}/.git' ';' -print0 | xargs -I {} -0 git -C {} pull -q"

# Colorize grep output (good for log files)
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
