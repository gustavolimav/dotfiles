# [parse_git_branch]
# This function will parse the git branch
function parse_git_branch {
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
	git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# [parse_git_current_branch_with_parantheses]
# This function will parse the git current branch with parantheses
function parse_git_current_branch_with_parantheses {
	parse_git_current_branch | sed 's/.*/(&)/'
}

function createBranch() {
	ticketCode=$1
	typeOfTicket=$2
	branchTitle=$3

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		echo -e "${GREEN}gcb${NC}"
		echo -e "${YELLOW}Usage:${NC} /bin/bash <ticketCode> <typeOfTicket> <branchTitle>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}ticketCode${NC}     The ticket code, e.g., LPD-31099"
		echo -e "  ${BLUE}typeOfTicket${NC}   The type of the ticket, e.g., 'test fix'. Words will be split by '_' and converted to uppercase."
		echo -e "  ${BLUE}branchTitle${NC}    The title of the branch, e.g., 'terms filter'. Words will be split by '_' and converted to uppercase."
		echo
		echo -e "${YELLOW}Example:${NC}"
		echo -e "  /bin/bash LPD-31099 \"test fix\" \"terms filter\""
		echo -e "  This will create a branch named: YYYY_DD_MM_TEST_FIX_LPD-31099_TERMS_FILTER"
		return
	fi

	# Get current date
	year=$(date +"%Y")
	day=$(date +"%d")
	month=$(date +"%m")

	# Convert typeOfTicket and branchTitle to uppercase and replace spaces with underscores
	typeOfTicketFormatted=$(echo "$typeOfTicket" | tr ' ' '_' | tr '[:lower:]' '[:upper:]')
	branchTitleFormatted=$(echo "$branchTitle" | tr ' ' '_' | tr '[:lower:]' '[:upper:]')

	# Construct branch name
	branchName="${year}_${day}_${month}_${typeOfTicketFormatted}_${ticketCode}_${branchTitleFormatted}"

	# Create the branch
	git checkout -b "$branchName"
}