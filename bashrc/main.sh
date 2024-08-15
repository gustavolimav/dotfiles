#!/bin/bash

BASH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASH_DIR/functions/work/customize_path.sh" # Load properties first
source "$BASH_DIR/functions/work/customize_alias.sh" # Load aliases
source "$BASH_DIR/functions/work/customize_passwords.sh" # Load passwords

customize_path
customize_aliases
customize_passwords

source "$BASH_DIR/functions/work/customize_api_key.sh" # Load passwords
source "$BASH_DIR/functions/work/db.sh" # Load functions related to databases
source "$BASH_DIR/functions/work/bundles.sh" # Load functions related to Liferay workspace setup
source "$BASH_DIR/functions/work/git.sh" # Load functions related to git
source "$BASH_DIR/functions/work/java.sh" # Load functions related to Java
source "$BASH_DIR/functions/work/others.sh" 

customize_prompt

source "$BASH_DIR/functions/work/solr.sh" # Load functions related to Solr
source "$BASH_DIR/functions/work/opensearch.sh" # Load functions related to OpenSearch

source ~/.local/share/blesh/ble.sh
shopt -s autocd

unset NPM_CONFIG_PREFIX # Adding this so I can use NVM