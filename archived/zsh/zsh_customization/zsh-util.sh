# Function to source files if they exist
function zsh_add_file() {
    [ -f "$1" ] && source "$1"
}

function zsh_add_plugin() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    echo $PLUGIN_NAME
    if [ -d "$ZSH_DIR/../plugins/$PLUGIN_NAME" ]; then 
        # For plugins
        zsh_add_file "$ZSH_DIR/../plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
        zsh_add_file "$ZSH_DIR/../plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
    else
        git clone "https://github.com/$1.git" "$HOME/../plugins/$PLUGIN_NAME"
    fi
}

function zsh_add_completion() {
    PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
    if [ -d "plugins/$PLUGIN_NAME" ]; then 
        # For completions
		completion_file_path=$(ls plugins/$PLUGIN_NAME/_*)
		fpath+="$(dirname "${completion_file_path}")"
        zsh_add_file "plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh"
    else
        git clone "https://github.com/$1.git" "plugins/$PLUGIN_NAME"
		fpath+=$(ls plugins/$PLUGIN_NAME/_*)
        [ -f .zccompdump ] && .zccompdump
    fi
	completion_file="$(basename "${completion_file_path}")"
	if [ "$2" = true ] && compinit "${completion_file:1}"
}

# Use lf to switch directories and bind it to ctrl-o
lfcd () {
    tmp="$(mktemp -uq)"
    trap 'rm -f $tmp >/dev/null 2>&1 && trap - HUP INT QUIT TERM PWR EXIT' HUP INT QUIT TERM PWR EXIT
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '^o' '^ulfcd\n'
