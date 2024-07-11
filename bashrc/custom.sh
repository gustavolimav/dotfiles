BASH_DIR=/home/me/dev/projects/dotfiles/bashrc

source "$BASH_DIR/functions/work/properties.sh" # Load properties first
source "$BASH_DIR/functions/work/alias.sh" # Load aliases
source "$BASH_DIR/functions/work/bundles.sh" # Load functions related to Liferay workspace setup
source "$BASH_DIR/functions/work/db.sh" # Load functions related to databases
source "$BASH_DIR/functions/work/git.sh" # Load functions related to git
source "$BASH_DIR/functions/work/java.sh" # Load functions related to Java
source "$BASH_DIR/functions/work/others.sh" 
source "$BASH_DIR/functions/work/solr.sh" # Load functions related to Solr
source "$BASH_DIR/functions/work/opensearch.sh" # Load functions related to OpenSearch

source ~/.local/share/blesh/ble.sh

unset NPM_CONFIG_PREFIX # Adding this so I can use NVM