function customize_path {
	export ANT_HOME="/opt/java/ant"
	export ANT_OPTS="-Xmx6144m"

	export DOCKER_HOST=unix:///run/user/$(id -u)/docker.sock

	export GRADLE_OPTS=${ANT_OPTS}

	if [ -z ${JAVA_HOME+x} ]
	then
		export JAVA_HOME="/opt/java/jdk"
	fi

	export LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/apr/lib"

	export LINUX_WITH_BTRFS=true

	export NPM_CONFIG_PREFIX=~/.npm-global

	export PATH="${ANT_HOME}/bin:${JAVA_HOME}/bin:${NPM_CONFIG_PREFIX}/bin:/opt/java/maven/bin:${HOME}/jpm/bin:/opt/quickemu:${PATH}"

    export IJ_CLONE_PATH=/home/me/dev/projects/liferay-intellij
    export BUNDLES_HOME=/home/me/dev/bundles
    export PROPERTIES_FILE_PATH=/home/$USER/dev/projects/properties
    export MARIADB_PASSWORD=L1f3ray

	export RED='\033[0;31m'
	export GREEN='\033[0;32m'
	export YELLOW='\033[1;33m'
	export BLUE='\033[1;34m'
	export NC='\033[0m' # No Color
}