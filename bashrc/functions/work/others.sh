function cd_module() {
	local git_dir="$(git rev-parse --show-toplevel)"

	local module_dir="$(
		git -C "${git_dir}" ls-files -- \
			':!:**/src/**' \
			\
			'*.bnd' \
			'*build.xml' \
			'*pom.xml' |

			#
			# Get the directory name with sed instead of dirname because it is much faster
			#

			sed -E \
				-e 's,[^/]*$,,g' \
				\
				-e 's,/$,,g' \
				-e '/^$/d' |

			#
			# Remove duplicates because some modules have more than one *.bnd file
			#

			uniq |

			#
			# Pass the results to fzf
			#
			fzf \
				--exit-0 \
				--no-multi \
				--query "$*" \
				--select-1 \
			;
	)"

	if [ -n "${module_dir}" ]
	then
		cd "${git_dir}/${module_dir}" || return 1
	fi
}

# MCD_RD_CLONE_PATH=/home/me/dev/projects/liferay-faster-deploy

# cd() {
# 	emulate -LR bash
# 		. $MCD_RD_CLONE_PATH/gitcd/gitcd $@
# }

function beforePR() {
    compileJava
    deploy
}

ij() {
	${IJ_CLONE_PATH}/intellij_libsources "$@"
}

intellij() {
	git_home
	/home/me/Downloads/ideaIU-2024.1.3/idea-IU-241.17890.1/bin/idea.sh .
}

function jira {
	xdg-open "https://liferay.atlassian.net/browse/${1}"
}

function open_sublime_git {
	local hash1=${1}

	if [ -z ${hash1} ]
	then
		hash1="$(git branch --show-current)"
	fi

	local repository_dir="$(git rev-parse --show-toplevel)"

	local branch=$(git config --get git-pull-request.${repository_dir}.update-branch)

	if [ -z ${branch} ]
	then
		branch="master"
	fi

	local hash2=${2}

	if [ -z ${hash2} ]
	then
		hash2=${branch}
	fi

	local hash_range="${hash2}..${hash1}"

	echo ""
	echo "Opening files in the range ${hash_range}."

	for file in $(git diff ${hash_range} --name-only | head -n 100)
	do
		/opt/sublime_text/sublime_text "${repository_dir}/${file}" 2>/dev/null || printf "\nUnable to open ${file}."
	done
}

function backport_lpd() {
	local lpd=$1

	echo "[Info] Backporting ${lpd}."

	local hashs_to_cp=$(get_git_hashs_formated $lpd)

	echo "[Info] Cherry-picking the following commits: ${hashs_to_cp}."

	git cherry-pick $hashs_to_cp

	echo "[Info] Done."
}


function customize_prompt {
	PS1="\[\e]0;\w\a\]\n\[\e[32m\]\u@\h \[\e[33m\]\w\[\e[0m\] \$(parse_git_current_branch_with_parentheses)\n\$ "

	#
	# https://forums.fedoraforum.org/showthread.php?326174-stop-konsole-highlighting-pasted-text
	# https://newbedev.com/remote-ssh-commands-bash-bind-warning-line-editing-not-enabled
	#

	#if [ -t 1 ]
	#then
	#	bind "set enable-bracketed-paste off"
	#fi
}

# [Execute Gradlew]
# This function will execute gradlew
function execute_gradlew {
	if [ -e gradlew ]
	then
		./gradlew ${@}
	elif [ -e ../gradlew ]
	then
		../gradlew ${@}
	elif [ -e ../../gradlew ]
	then
		../../gradlew ${@}
	elif [ -e ../../../gradlew ]
	then
		../../../gradlew ${@}
	elif [ -e ../../../../gradlew ]
	then
		../../../../gradlew ${@}
	elif [ -e ../../../../../gradlew ]
	then
		../../../../../gradlew ${@}
	elif [ -e ../../../../../../gradlew ]
	then
		../../../../../../gradlew ${@}
	elif [ -e ../../../../../../../gradlew ]
	then
		../../../../../../../gradlew ${@}
	elif [ -e ../../../../../../../../gradlew ]
	then
		../../../../../../../../gradlew ${@}
	elif [ -e ../../../../../../../../../gradlew ]
	then
		../../../../../../../../../gradlew ${@}
	else
		echo "Unable to find locate Gradle wrapper."
	fi
}

gw () {
	local root_level
	root_level=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -n $root_level && -f "$root_level/gradlew" ]]
	then
		root_level="$root_level/gradlew"
	else
		root_level=$(command -v gradle)
	fi
	"$root_level" --console=rich "$@"
}

# [poshi]
# This function will execute poshi
# Example: poshi Elasticsearch7#ReindexWithSyncExecutionMode
function poshi() {
	APP_TEST="$1"
	ant -f build-test.xml run-selenium-test -Dtest.class=$APP_TEST
}