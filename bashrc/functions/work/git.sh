function parse_git_branch {
	GIT_DIR_NAME=$(git rev-parse --show-toplevel)

	GIT_DIR_NAME=${GIT_DIR_NAME##*/}

	if [[ "${GIT_DIR_NAME}" =~ -ee-[0-9][^\-]*$ ]]; then
		echo "ee-${GIT_DIR_NAME##*-ee-}"
	elif [[ "${GIT_DIR_NAME}" =~ -[0-9][^\-]*$ ]]; then
		echo "${GIT_DIR_NAME##*-}"
	elif [[ "${GIT_DIR_NAME}" =~ com-liferay-osb-asah-private$ ]]; then
		echo "7.0.x"
	elif [[ "${GIT_DIR_NAME}" =~ -private$ ]]; then
		echo "${GIT_DIR_NAME}" | sed 's/.*-\([^\-]*\)-private$/\1-private/'
	else
		echo "master"
	fi
}

function git_home() {
	local git_root
	git_root=$(git rev-parse --show-toplevel 2>/dev/null)
	if [[ -z "$git_root" ]]; then
		echo "Not a git repository."
	else
		cd "$git_root" || return
	fi
}

function git_grep {
	if [ ${#} -eq 1 ]; then
		git --no-pager grep --files-with-matches "${1}"
	elif [ ${#} -eq 2 ]; then
		git --no-pager grep --files-with-matches "${1}" -- "${2}"
	elif [ ${#} -eq 3 ]; then
		git --no-pager grep --files-with-matches "${1}" -- "${2}" "${3}"
	elif [ ${#} -eq 4 ]; then
		git --no-pager grep --files-with-matches "${1}" -- "${2}" "${3}" "${4}"
	fi
}

function git_init() {
	if [ -z "$1" ]; then
		printf "%s\n" "Please provide a directory name."
	else
		mkdir "$1"
		builtin cd "$1"
		pwd
		git init
		touch readme.md .gitignore LICENSE
		echo "# $(basename $PWD)" >>readme.md
	fi
}

function parse_git_current_branch {
	git rev-parse --abbrev-ref HEAD 2>/dev/null
}

function parse_git_current_branch_with_parentheses {
	parse_git_current_branch | sed 's/.*/(&)/'
}

function createBranch() {
	ticketCode=$1
	typeOfTicket=$2
	branchTitle=$3

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		echo -e "${YELLOW}Usage:${NC} createBranch <ticketCode> <typeOfTicket> <branchTitle>"
		echo
		echo -e "${YELLOW}Arguments:${NC}"
		echo -e "  ${BLUE}ticketCode${NC}     The ticket code, e.g., LPD-31099"
		echo -e "  ${BLUE}typeOfTicket${NC}   The type of the ticket, e.g., 'test fix'. Words will be split by '_' and converted to uppercase."
		echo -e "  ${BLUE}branchTitle${NC}    The title of the branch, e.g., 'terms filter'. Words will be split by '_' and converted to uppercase."
		echo
		echo -e "${YELLOW}Example:${NC}"
		echo -e "  createBranch LPD-31099 \"test fix\" \"terms filter\""
		echo -e "  This will create a branch named: YYYY_DD_MM_TEST_FIX_LPD-31099_TERMS_FILTER"
		return
	fi

	# Get current date
	year=$(date +"%Y")
	day=$(date +"%d")
	month=$(date +"%m")

	# Convert typeOfTicket to uppercase and replace spaces with underscores
	typeOfTicketFormatted=$(echo "$typeOfTicket" | tr ' ' '_' | tr '[:lower:]' '[:upper:]')

	# replace branchTitle spaces with underscores
	branchTitleFormatted=$(echo "$branchTitle" | tr ' ' '_')

	# Construct branch name
	branchName="${year}_${day}_${month}_${typeOfTicketFormatted}_${ticketCode}_${branchTitleFormatted}"

	# Create the branch
	git checkout -b "$branchName"
}

function commit_with_pattern() {
	local commitMessage=$1
	local ticketCode=$2

	local folderName=$(find_foulder_with_lfrbuild)

	if [[ -z "$ticketCode" ]]; then
		ticketCode=$(git log -1 --pretty=format:%s | awk '{print $1}')
	fi

	local jiraLink="https://liferay.atlassian.net/browse/${ticketCode}"

	git commit -m "${ticketCode} ${folderName}: ${commitMessage}" -m "${jiraLink}"
}

function git_fetch_pr {
	if [[ "${1}" != */github\.com/* ]] ||
		[[ "${1}" != */pull/* ]]; then
		echo "URL ${1} does not point to a GitHub pull request."
	else
		IFS='/' read -r -a github_pr_parts <<<"${1}"

		git fetch --no-tags git@github.com:${github_pr_parts[3]}/${github_pr_parts[4]}.git pull/${github_pr_parts[6]}/head:pr-${github_pr_parts[6]}
	fi
}

function check_git_available() {
	if ! command -v git &>/dev/null; then
		echo "git command not found. Please install git."
		return 1
	fi
	return 0
}

function check_inside_git_repo() {
	if ! git rev-parse --is-inside-work-tree &>/dev/null; then
		echo "Not inside a Git repository. Please navigate to a Git repository."
		return 1
	fi
	return 0
}

function get_ticket_code_from_commit() {
	ticketCode=$(git log -1 --pretty=format:%s | awk '{print $1}')

	echo "$ticketCode"
}

function create_rebase_script() {
	local rebaseScript=$(mktemp)
	cat <<EOF >"$rebaseScript"
#!/bin/bash
sed -i 's/^pick /edit /' "\$1"
EOF
	chmod +x "$rebaseScript"
	echo "$rebaseScript"
}

function amend_commit_message() {
	check_git_available || return 1
	check_inside_git_repo || return 1

	local ticketCode=$1

	if [[ -z "$ticketCode" ]]; then
		ticketCode=$(get_ticket_code_from_commit "$ticketCode")
	fi

	if [[ ! $ticketCode =~ ^LPD- ]]; then
		echo "Invalid ticket code. Ticket code must start with LPD-."
		return
	fi

	local jiraLink="https://liferay.atlassian.net/browse/${ticketCode}"

	local folderName=$(find_foulder_with_lfrbuild)

	local commitMessage=$(git log --format=%B -n 1 HEAD)
	local pattern="${ticketCode} ${folderName}:"

	if [[ $commitMessage == "$pattern"* ]]; then
		echo "Commit message already follows the pattern."
		return
	fi

	git commit --amend --no-edit --message="${ticketCode} ${folderName}: $commitMessage" --message="${jiraLink}"
}

function find_foulder_with_lfrbuild() {
	local commitHash=$(git log --format=%H -n 1 HEAD)
	local folderName=$(git diff-tree --no-commit-id --name-only -r "$commitHash" | head -n 1 | xargs dirname)
	local maxIterations=20
	local iterationCount=0

	while [[ ! -f "$folderName/.lfrbuild-portal" && "$folderName" != "/" && $iterationCount -lt $maxIterations ]]; do
		folderName=$(dirname "$folderName")
		((iterationCount++))
	done

	if [[ "$folderName" == "/" || "$folderName" == "." || $iterationCount -ge $maxIterations ]]; then
		folderName=$(basename "$(pwd)")
	fi

	folderName=$(basename "$folderName")

	echo "$folderName"
}

function apply_pattern_to_commits() {
	check_git_available || return 1
	check_inside_git_repo || return 1

	local numCommits=$1
	local ticketCode=$2

	if [[ -z "$numCommits" ]]; then
		echo "Number of commits must be specified."
		return 1
	fi

	local rebaseScript=$(create_rebase_script)

	GIT_SEQUENCE_EDITOR="$rebaseScript" git rebase -i HEAD~"$numCommits"

	if [[ $? -ne 0 ]]; then
		echo "Rebase failed. Please resolve conflicts and continue rebase manually."
		return 1
	fi

	for i in $(seq 1 $numCommits); do
		amend_commit_message "$ticketCode"
		git rebase --continue

		if [[ $? -ne 0 ]]; then
			echo "Rebase failed during commit amending. Please resolve conflicts and continue rebase manually."
			return 1
		fi
	done

	rm "$rebaseScript"
	echo "Pattern applied to $numCommits commits."
}
