function switch_to_java_6 {
	export JAVA_HOME="/opt/java/jdk6"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}

function switch_to_java_7 {
	export JAVA_HOME="/opt/java/jdk7"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}

function switch_to_java_8 {
	export JAVA_HOME="/opt/java/jdk8"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}

function switch_to_java_11 {
	export JAVA_HOME="/opt/java/jdk11"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}

function switch_to_java_17 {
	export JAVA_HOME="/opt/java/jdk17"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}