# Ant commands
alias ac="ant compile"
alias acc="ant clean compile"
alias ad="ant deploy"
alias af="ant format-source"
alias afcb="ant format-source-current-branch"
alias baselineKernel="ant -Dbaseline.jar.report.level=persist clean jar"

# Docker commands

alias d="docker"
alias dmysqlclient="docker exec -it galatians-mysql mysql -utest -ptest"
alias dmysqlserver="docker run --name galatians-mysql --rm -d -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -e MYSQL_DATABASE=lportal -e MYSQL_PASSWORD=test -e MYSQL_USER=test -p 3306:3306 mysql:8 --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci"
alias dpsqlclient="docker exec -it galatians-psql psql -U postgres"
alias dpsqlserver="docker run --name galatians-psql --rm -d -e POSTGRES_PASSWORD=test -p 5432:5432 postgres:13"

# Git commands

alias g="git"
alias gcp="git cherry-pick"
alias grbi="git rebase -i"
alias gi="gpr info"
alias gg="git_grep"
alias gpr="~/dev/projects/git-tools/git-pull-request/git-pull-request.sh"
alias ghome="git_home"

# Directory commands

alias cdm="cd_module"
alias cdwt="cd ~/dev/projects/worktrees"
alias cdt="cd ~/dev/projects/liferay-portal"
alias cdp="cd ~/dev/projects"
alias cdbh="${BUNDLES_HOME}"

# Liferay developer commands

alias kpt="fuser -k 8080/tcp"
alias kkibana="fuser -k 5601/tcp"
alias gwd="gw deploy"
alias gwcd="gw clean deploy"
alias gwti='gw testIntegration --tests'
alias gwt='gw test --tests'
alias gwbr='gw buildREST'
alias gwbs='gw bS'
alias sf="gw formatSource"
alias ijdxp= "setUpLiferayDXP_Intellij"

# General utility commands

alias run-vpn="sudo openvpn --config client.ovpn --auth-user-pass /home/me/vpn/pass.txt"
alias la="ls -la --color=auto"
alias la="ls --color=auto"  # Note: This alias overrides the previous 'la' alias
alias osub="/opt/sublime_text/sublime_text ${@}"
alias lockscreen="xscreensaver-command --lock"
alias fakesmtp="cd /home/me/projects/fake-smtp/fakeSMTP-latest && java -jar fakeSMTP-2.0.jar"

# Elasticsearch and Kibana commands
alias kibana="~/Downloads/kibana-oss-7.10.2-linux-x86_64/kibana-7.10.2-linux-x86_64/./bin/kibana"
alias elasticsearch="~/elasticsearch/elasticsearch-7.17.6-linux-x86_64/elasticsearch-7.17.6/bin/./elasticsearch"

