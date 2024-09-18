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

function ij() {
	${IJ_CLONE_PATH}/intellij_libsources "$@"
}

function intellij() {
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

function print_help_message() {
	local functionName="$1"

	case "$functionName" in
	backport_lpd)
		echo -e "${YELLOW}Usage:${NC} backport_lpd <lpd> [remote] [branch]"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}lpd${NC}     The lpd to backport."
		echo -e "  ${BLUE}remote${NC}  The remote to backport from. (optional)"
		echo -e "  ${BLUE}branch${NC}  The branch to backport from. (optional)"
		echo
		echo -e "${YELLOW}Description:${NC} Cherry-picks commits from the specified remote and branch with the specified LPD."
		;;
	create_branch)
		echo -e "${YELLOW}Usage:${NC} create_branch <ticketCode> <typeOfTicket> <branchTitle>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}ticketCode${NC}     The ticket code, e.g., LPD-31099"
		echo -e "  ${BLUE}typeOfTicket${NC}   The type of the ticket, e.g., 'test fix'. Words will be split by '_' and converted to uppercase."
		echo -e "  ${BLUE}branchTitle${NC}    The title of the branch, e.g., 'terms filter'. Words will be split by '_' and converted to uppercase."
		echo
		echo -e "${YELLOW}Example:${NC}"
		echo -e "  createBranch LPD-31099 \"test fix\" \"terms filter\""
		echo -e "  This will create a branch named: YYYY_DD_MM_TEST_FIX_LPD-31099_TERMS_FILTER"
		;;
	git_home)
		echo -e "${YELLOW}Usage:${NC} git_home"
		echo
		echo -e "${YELLOW}Description:${NC} Changes the current directory to the root of the current Git repository."
		;;
	git_grep)
		echo -e "${YELLOW}Usage:${NC} git_grep <pattern> [path] [ref]"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}pattern${NC}   The pattern to search for."
		echo -e "  ${BLUE}path${NC}      The path to limit the search to. (optional)"
		echo -e "  ${BLUE}ref${NC}       The reference to search in. (optional)"
		echo
		echo -e "${YELLOW}Example:${NC}"
		echo -e "  gitGrep 'TODO' src/ main"
		echo -e "  This will search for 'TODO' in files under the 'src/' directory in the 'main' branch."
		;;
	git_init)
		echo -e "${YELLOW}Usage:${NC} git_init <directory>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}directory${NC}   The name of the directory to create and initialize as a Git repository."
		echo
		echo -e "${YELLOW}Example:${NC}"
		echo -e "  gitInit myproject"
		echo -e "  This will create a directory named 'myproject', change into it, initialize it as a Git repository, and create some initial files."
		;;
	parse_git_current_branch)
		echo -e "${YELLOW}Usage:${NC} parse_git_current_branch"
		echo
		echo -e "${YELLOW}Description:${NC} Retrieves the name of the current Git branch."
		;;
	parse_git_current_branch_with_parentheses)
		echo -e "${YELLOW}Usage:${NC} parse_git_current_branch_with_parentheses"
		echo
		echo -e "${YELLOW}Description:${NC} Retrieves the name of the current Git branch and wraps it in parentheses."
		;;
	create_pull_request)
		echo -e "${YELLOW}Usage:${NC} create_pull_request <userToSend> [ticketCode] [branchToSend] [prTitle]"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}userToSend${NC}   The user to send the pull request to."
		echo -e "  ${BLUE}ticketCode${NC}   The ticket code associated with the pull request. (optional)"
		echo -e "  ${BLUE}branchToSend${NC} The branch to send the pull request from. (optional)"
		echo -e "  ${BLUE}prTitle${NC}      The title of the pull request. (optional)"
		echo
		echo -e "${YELLOW}Description:${NC} Creates a pull request with the specified repository and ticket code."
		;;
	commit_with_pattern)
		echo -e "${YELLOW}Usage:${NC} commit_with_pattern <commitMessage> [ticketCode] [commitDescription]"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}commitMessage${NC}   The commit message."
		echo -e "  ${BLUE}ticketCode${NC}      The ticket code associated with the commit. (optional)"
		echo -e "  ${BLUE}commitDescription${NC} The description of the commit. (optional)"
		echo
		echo -e "${YELLOW}Description:${NC} Commits changes with the specified commit message and ticket code."
		;;
	git_fetch_pr)
		echo -e "${YELLOW}Usage:${NC} git_fetch_pr <pullRequestUrl>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}pullRequestUrl${NC}   The URL of the pull request."
		echo
		echo -e "${YELLOW}Description:${NC} Fetches the changes from a GitHub pull request."
		;;
	check_git_available)
		echo -e "${YELLOW}Usage:${NC} check_git_available"
		echo
		echo -e "${YELLOW}Description:${NC} Checks if the git command is available."
		;;
	check_inside_git_repo)
		echo -e "${YELLOW}Usage:${NC} check_inside_git_repo"
		echo
		echo -e "${YELLOW}Description:${NC} Checks if the current directory is inside a Git repository."
		;;
	get_ticket_code_from_commit)
		echo -e "${YELLOW}Usage:${NC} get_ticket_code_from_commit"
		echo
		echo -e "${YELLOW}Description:${NC} Retrieves the ticket code from the latest commit message."
		;;
	create_rebase_script)
		echo -e "${YELLOW}Usage:${NC} create_rebase_script"
		echo
		echo -e "${YELLOW}Description:${NC} Creates a temporary rebase script."
		;;
	amend_commit_message)
		echo -e "${YELLOW}Usage:${NC} amend_commit_message [ticketCode]"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}ticketCode${NC}   The ticket code associated with the commit. (optional)"
		echo
		echo -e "${YELLOW}Description:${NC} Amends the commit message with the specified ticket code."
		;;
	find_foulder_with_lfrbuild)
		echo -e "${YELLOW}Usage:${NC} apply_pattern_to_commits"
		echo
		echo -e "${YELLOW}Description:${NC} Finds the folder with the .lfrbuild-portal file."
		;;
	apply_pattern_to_commits)
		echo -e "${YELLOW}Usage:${NC} apply_pattern_to_commits <numCommits> [ticketCode]"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}numCommits${NC}    The number of commits to apply the pattern to."
		echo -e "  ${BLUE}ticketCode${NC}    The ticket code associated with the commits. (optional)"
		echo
		echo -e "${YELLOW}Description:${NC} Applies the pattern to the specified number of commits."
		;;
	get_git_hashs_formated)
		echo -e "${YELLOW}Usage:${NC} get_git_hashs_formated <remote> <lpd>"
		echo 
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}remote${NC} The remote to get the hashs from."
		echo -e "  ${BLUE}lpd${NC}    The lpd to get the hashs from."
		echo
		echo -e "${YELLOW}Description:${NC} Get the hashs from the lpd."
		;;
	git_add_worktree)
		echo -e "${YELLOW}Usage:${NC} git_add_worktree <branch>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}branch${NC}    The branch to create the worktree."
		echo
		echo -e "${YELLOW}Description:${NC} Add a worktree with the branch."
		;;
	git_fetch_tag)
		echo -e "${YELLOW}Usage:${NC} git_fetch_tag <tag>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}tag${NC}    The tag to add."
		echo
		echo -e "${YELLOW}Description:${NC} Add a tag."
		;;
	*)
		echo "No help message available for $functionName"
		;;
	esac
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

function gw () {
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