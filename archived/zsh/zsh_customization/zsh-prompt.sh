# Autoload functions
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

# Enable git for vcs_info
# zstyle ':vcs_info:*' enable git

# Function to update VCS info asynchronously
update_vcs_info() {
    echo "update_vcs_info called"
    vcs_info || echo "vcs_info failed"
    zle && zle .reset-prompt || echo "zle reset-prompt failed"
}

# Customize the VCS information
# zstyle ':vcs_info:git:*' formats '%F{yellow}%b%f%F{red}%c%f%F{green}%u%f '
# zstyle ':vcs_info:git:*' actionformats '%F{yellow}%b|%a%f '

# Command execution time
TIMER=0
preexec() {
    echo "preexec called"
    TIMER=$SECONDS
}

precmd() {
    if [[ $TIMER -gt 0 ]]; then
        ELAPSED_TIME=$(($SECONDS - $TIMER))
        TIMER_FORMAT="%F{cyan}[$ELAPSED_TIME sec]%f "
    else
        TIMER_FORMAT=''
    fi
}

echo "aqui"

# Register hooks
add-zsh-hook preexec preexec
add-zsh-hook precmd update_vcs_info
add-zsh-hook precmd precmd

# Return status of the last executed command
function return_status() {
    if [ $? -eq 0 ]; then
        echo "%F{green}✔%f"
    else
        echo "%F{red}✖%f"
    fi
}

# Shorten directory path
function prompt_dir() {
    echo "%F{cyan}%3~%f"
}

# Final Prompt
setopt PROMPT_SUBST
PROMPT='%F{magenta}%n@%m%f %B%F{blue}%T%f%b $(prompt_dir) $(return_status) ${vcs_info_msg_0_} ${TIMER_FORMAT}
%# '

# Initialize vcs_info
vcs_info
