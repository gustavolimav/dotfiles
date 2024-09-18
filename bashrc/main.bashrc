#!/bin/bash

BASH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$BASH_DIR/functions/work/customize_path.bashrc" # Load properties first
source "$BASH_DIR/functions/work/customize_alias.bashrc" # Load aliases
source "$BASH_DIR/functions/work/customize_passwords.bashrc" # Load passwords

customize_path
customize_api_keys
customize_aliases
customize_passwords

source "$BASH_DIR/functions/work/customize_api_key.bashrc" # Load passwords
source "$BASH_DIR/functions/work/db.bashrc" # Load functions related to databases
source "$BASH_DIR/functions/work/bundles.bashrc" # Load functions related to Liferay workspace setup
source "$BASH_DIR/functions/work/git.bashrc" # Load functions related to git
source "$BASH_DIR/functions/work/java.bashrc" # Load functions related to Java
source "$BASH_DIR/functions/work/others.bashrc" # Load extra functions

customize_prompt

source "$BASH_DIR/functions/work/solr.bashrc" # Load functions related to Solr
source "$BASH_DIR/functions/work/opensearch.bashrc" # Load functions related to OpenSearch

source ~/.local/share/blesh/ble.sh # Load Ble.sh further informations here: https://github.com/akinomyoga/ble.sh
shopt -s autocd # Enable autocd

unset NPM_CONFIG_PREFIX # Adding this so I can use NVM

export HISTSIZE=50000; 
export HISTFILESIZE=50000;