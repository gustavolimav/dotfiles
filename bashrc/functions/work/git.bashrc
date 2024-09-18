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

function create_branch() {
	ticketCode=$1
	typeOfTicket=$2
	branchTitle=$3

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message create_branch
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
	branchName="${year}_${month}_${day}_${typeOfTicketFormatted}_${ticketCode}_${branchTitleFormatted}"

	# Create the branch
	git checkout -b "$branchName"
}


function generate_ticket_url() {
	local ticketCode="$1"

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message generate_ticket_url
		return
	fi

	echo "https://liferay.atlassian.net/browse/$ticketCode"
}

function fetch_ticket_name() {
	local ticketCode="$1"

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message fetch_ticket_name
		return
	fi

	local response=$(curl -s -u ${JIRA_USERNAME}:${JIRA_API_KEY} -X GET -H "Content-Type: application/json" "https://liferay.atlassian.net/rest/api/3/issue/$ticketCode")

	local ticketName=$(echo "$response" | jq -r '.fields.summary')

	echo "$ticketName"
}

function backport_() {
	local backportTicketCode=$1
    local ticketName=$(fetch_ticket_name "$backportTicketCode")

    # Split the ticketName by spaces first to isolate the branch name and ticket code
    IFS=' ' read -r -a parts <<< "$ticketName"

    # Extract the branch name and ticket code
    local branchName="${parts[0]}"
    local ticketCode="${parts[1]}"

    # Extract the ticket description which starts from the third part
    # Join the remaining parts after the second element
    local ticketTitle=$(printf '%s ' "${parts[@]:2}")

    # Remove the leading "| " from ticketDescription
    ticketTitle="${ticketTitle#*| }"

	# Convert branchName to lowercase
    branchName=$(echo "$branchName" | tr '[:upper:]' '[:lower:]')

	# Go to projects folder
	cdp

	# Go to the liferay-portal-ee folder
	cd liferay-portal-ee

	# Go to master-private branch
	git checkout master-private

	# Go to the branch
	git checkout $branchName

	# Pull the latest changes
	git pull upstream $branchName

	# Create the backport branch
	git checkout -b $backportTicketCode

	# Cherry pick the commits
	backport_lpd "$ticketCode" "bchan"

	# Pr title using pattern
	local prTitle = "${ticketCode} | ${branchName}"

	# Create PR
	create_pull_request liferay $ticketCode $branchName $prTitle
}

function backport_lpd() {
	local lpd=$1
	local remote=$2
	local branch=$3

	if [ -z ${lpd} ]
	then
		print_help_message backport_lpd
		return
	fi

	if [ -z ${remote} ]
	then
		remote="upstream"
	fi

	if [ -z ${branch} ]
	then
		branch="master"
	fi

	echo "[Info] Cherry-picking commits from ${remote} with ticketCode: ${lpd} "

	local hashs_to_cp=$(get_git_hashs_formated ${remote}/${branch} ${lpd})

	if [ -z ${hashs_to_cp} ]
	then
		echo "[Error] No commits found."
		return
	fi

	echo "[Info] Cherry-picking the following commits: ${hashs_to_cp}."

	git cherry-pick $hashs_to_cp

	echo "[Info] Cherry-pick Done."
}

function create_pull_request() {
	local userToSend="$1"
	local ticketCode="$2"
	local branchToSend="$3"
	local prTitle="$4"

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message create_pull_request
		return
	fi

	if [[ -z "$userToSend" ]]; then
		echo "User to send must be specified."
		return 1
	fi

	if [[ -z "$ticketCode" ]]; then
		ticketCode=$(get_ticket_code_from_commit)
	fi

	local ticketName=$(fetch_ticket_name "$ticketCode")

	local url=$(generate_ticket_url "$ticketCode")

	local defaultPrTitle="${ticketCode}: ${ticketName}"
    local prBody="Ticket: $url"

    if [ "$prTitle" == "" ]; then
        prTitle="$defaultPrTitle"
    fi

	if [[ -n "$branchToSend" ]]; then
		gpr -b "$branchToSend" -u "$userToSend" submit "$prBody" "$prTitle"
		return
	fi

	gpr -u "$userToSend" submit "$prBody" "$prTitle"
}

function commit_with_pattern() {
	local commitMessage=$1
	local ticketCode=$2
	local commitDescription=$3

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message commit_with_pattern
		return
	fi

	if [[ -z "$commitMessage" ]]; then
		echo "Commit message must be specified."
		return 1
	fi

	if [[ -z "$ticketCode" ]]; then
		ticketCode=$(get_ticket_code_from_commit)
	fi

	local folderName=$(find_foulder_with_lfrbuild)

	if [[ -z "$ticketCode" ]]; then
		ticketCode=$(git log -1 --pretty=format:%s | awk '{print $1}')
	fi

	local jiraLink=$(generate_ticket_url "$ticketCode")

	git commit -m "${ticketCode} ${folderName}: ${commitMessage}" -m "${commitDescription}" -m "${jiraLink}"
}

function git_fetch_pr {

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message git_fetch_pr
		return
	fi

	if [[ "${1}" != */github\.com/* ]] ||
		[[ "${1}" != */pull/* ]]; then
		echo "URL ${1} does not point to a GitHub pull request."
	else
		IFS='/' read -r -a github_pr_parts <<<"${1}"

		git fetch --no-tags git@github.com:${github_pr_parts[3]}/${github_pr_parts[4]}.git pull/${github_pr_parts[6]}/head:pr-${github_pr_parts[6]}
	fi
}

function check_git_available() {

	if [ "$1" == "help" ]; then
		print_help_message check_git_available
		return
	fi

	if ! command -v git &>/dev/null; then
		echo "git command not found. Please install git."
		return 1
	fi
	return 0
}

function check_inside_git_repo() {

	if [ "$1" == "help" ]; then
		print_help_message check_inside_git_repo
		return
	fi

	if ! git rev-parse --is-inside-work-tree &>/dev/null; then
		echo "Not inside a Git repository. Please navigate to a Git repository."
		return 1
	fi
	return 0
}

function get_ticket_code_from_commit() {

	if [ "$1" == "help" ]; then
		print_help_message get_ticket_code_from_commit
		return
	fi

	ticketCode=$(git log -1 --pretty=format:%s | awk '{print $1}')

	echo "$ticketCode"
}

function create_rebase_script() {
	if [ "$1" == "help" ]; then
		print_help_message create_rebase_script
		return
	fi

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

	if [ "$1" == "help" ] || [ "$1" == "" ]; then
		print_help_message amend_commit_message
		return
	fi

	if [[ -z "$ticketCode" ]]; then
		ticketCode=$(get_ticket_code_from_commit "$ticketCode")
	fi

	if [[ ! $ticketCode =~ ^LPD- ]]; then
		echo "Invalid ticket code. Ticket code must start with LPD-."
		return
	fi

	local jiraLink=$(generate_ticket_url "$ticketCode")

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

	if [ "$1" == "help" ]; then
		print_help_message find_foulder_with_lfrbuild
		return
	fi

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

	if [ "$1" == "help" ]; then
		print_help_message apply_pattern_to_commits
		return
	fi

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

function get_git_hashs_formated() {
	local remote=$1
	local lpd=$2
	
	local formated_git_hashs=$(git log $remote --grep $lpd --pretty=format:"%H%n" | tac | paste -sd " " -)

	echo $formated_git_hashs
}

function git_fetch_tag() {
	local worktreePath=~/dev/projects/worktree/$1

	if [[ $1 == "" ]]; then
		print_help_message git_fetch_tag
		return
	fi

	git fetch --no-tags upstream tags/$1:tags/$1
}

function git_add_worktree() {
	local worktreePath=~/dev/projects/worktree/$1

	if [[ $1 == "" ]]; then
		print_help_message git_add_worktree
		return
	fi

	git worktree add "$worktreePath" $1

	echo "[Info] Worktree was added in $worktreePath"
}
