function parse_git_branch {
	emulate -LR bash
			GIT_DIR_NAME=$(git rev-parse --show-toplevel)

			GIT_DIR_NAME=${GIT_DIR_NAME##*/}

			if [[ "${GIT_DIR_NAME}" =~ -ee-[0-9][^\-]*$ ]]
			then
				echo "ee-${GIT_DIR_NAME##*-ee-}"
			elif [[ "${GIT_DIR_NAME}" =~ -[0-9][^\-]*$ ]]
			then
				echo "${GIT_DIR_NAME##*-}"
			elif [[ "${GIT_DIR_NAME}" =~ com-liferay-osb-asah-private$ ]]
			then
				echo "7.0.x"
			elif [[ "${GIT_DIR_NAME}" =~ -private$ ]]
			then
				echo "${GIT_DIR_NAME}" | sed 's/.*-\([^\-]*\)-private$/\1-private/'
			else
				echo "master"
			fi
}

function git_home() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2> /dev/null)
    if [[ -z "$git_root" ]]; then
        echo "Not a git repository."
    else
        cd "$git_root" || return
    fi
}

# [Git Grep]
# This function will execute git grep
function git_grep {
	emulate -LR bash
			if [ ${#} -eq 1 ]
			then
				git --no-pager grep --files-with-matches "${1}"
			elif [ ${#} -eq 2 ]
			then
				git --no-pager grep --files-with-matches "${1}" -- "${2}"
			elif [ ${#} -eq 3 ]
			then
				git --no-pager grep --files-with-matches "${1}" -- "${2}" "${3}"
			elif [ ${#} -eq 4 ]
			then
				git --no-pager grep --files-with-matches "${1}" -- "${2}" "${3}" "${4}"
			fi
}

# [git_init]
# This function will initialize a git repository
function git_init() {
	emulate -LR bash
				if [ -z "$1" ]; then
						printf "%s\n" "Please provide a directory name.";
				else
						mkdir "$1";
						builtin cd "$1";
						pwd;
						git init;
						touch readme.md .gitignore LICENSE;
						echo "# $(basename $PWD)" >> readme.md
				fi
}

# [parse_git_current_branch]
# This function will parse the git current branch
function parse_git_current_branch {
	emulate -LR bash
			git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# [parse_git_current_branch_with_parantheses]
# This function will parse the git current branch with parantheses
function parse_git_current_branch_with_parantheses {
	emulate -LR bash
			parse_git_current_branch | sed 's/.*/(&)/'
}