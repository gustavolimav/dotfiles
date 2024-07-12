function customize_aliases {

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
	alias gfpr="git_fetch_pr ${1}"
	alias ghome="git_home"
	alias gcb="createBranch"

	# Directory commands

	alias cdm="cd_module"
	alias cdt="cd ~/dev/projects/liferay-portal"
	alias cdp="cd ~/dev/projects"
	alias cdbh="${BUNDLES_HOME}"

	# Java commands

	alias java6="switch_to_java_6"
	alias java7="switch_to_java_7"
	alias java8="switch_to_java_8"
	alias java11="switch_to_java_11"
	alias java17="switch_to_java_17"

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

	# General utility commands

	alias la="ls -la --group-directories-first"
	alias more="more -e"
	alias osub="/opt/sublime_text/sublime_text ${@}"
	alias osubg="open_sublime_git ${@}"

	#
	# Usage:
	#
	#    osubg
	#    osubg <hash1>
	#    osubg <hash1> <hash2>
	#

	alias lockscreen="xscreensaver-command --lock"
	alias fakesmtp="cd /home/me/projects/fake-smtp/fakeSMTP-latest && java -jar fakeSMTP-2.0.jar"
	alias p="/usr/local/bin/liferay_patcher"

	# Elasticsearch and Kibana commands
	alias kibana="~/Downloads/kibana-oss-7.10.2-linux-x86_64/kibana-7.10.2-linux-x86_64/./bin/kibana"
	alias elasticsearch="~/elasticsearch/elasticsearch-7.17.6-linux-x86_64/elasticsearch-7.17.6/bin/./elasticsearch"

	# playwright
	alias pw="npm run playwright -- test -g"
}