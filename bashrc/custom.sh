BASH_DIR=/home/me/dev/projects/dotfiles/bashrc

source "$BASH_DIR/aliases/work.sh"
source "$BASH_DIR/aliases/zsh.sh"
source "$BASH_DIR/functions/work/bundles.sh"
source "$BASH_DIR/functions/work/db.sh"
source "$BASH_DIR/functions/work/git.sh"
source "$BASH_DIR/functions/work/gw.sh"
source "$BASH_DIR/functions/work/java.sh"
source "$BASH_DIR/functions/work/ci.sh"
source "$BASH_DIR/functions/work/others.sh"
source "$BASH_DIR/functions/work/properties.sh"
source "$BASH_DIR/functions/work/solr.sh"
source "$BASH_DIR/functions/work/opensearch.sh"

unset NPM_CONFIG_PREFIX # Adding this so I can use NVM