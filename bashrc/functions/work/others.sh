# [CD MODULE]
# This function will cd to the module you select
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

ij() {
	${IJ_CLONE_PATH}/intellij_libsources "$@"
}

intellij() {
	ghome
	/home/me/Downloads/ideaIU-2024.1.3/idea-IU-241.17890.1/bin/idea.sh .
}

# MCD_RD_CLONE_PATH=/home/me/dev/projects/liferay-faster-deploy

# cd() {
# 	emulate -LR bash
# 		. $MCD_RD_CLONE_PATH/gitcd/gitcd $@
# }

# [Customize Path]
# This function will customize the path
function customize_path {
	export ANT_HOME="/opt/java/ant"
	export ANT_OPTS="-Xmx6144m"

	export GRADLE_OPTS=${ANT_OPTS}

	if [ -z ${JAVA_HOME+x} ]
	then
		export JAVA_HOME="/opt/java/jdk"
	fi

	# export NPM_CONFIG_PREFIX=~/.npm-global

	export PATH="${ANT_HOME}/bin:${JAVA_HOME}/bin:${NPM_CONFIG_PREFIX}/bin:/opt/java/maven/bin:${PATH}"
}

# [Execute Gradlew]
# This function will execute gradlew
function execute_gradlew {
	if [ -e ../gradlew ]
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

# # [gw]
# # This function will execute gradlew
# function gw {
# 	emulate -LR bash
# 			execute_gradlew "${@//\//:}" --daemon
# }

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

customize_path