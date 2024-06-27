# [switch_to_java_7]
# This function will switch to java 7
function switch_to_java_7 {	
	export JAVA_HOME="/opt/java/jdk7"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}

# [switch_to_java_8]
# This function will switch to java 8
function switch_to_java_8 {
	export JAVA_HOME="/opt/java/jdk8"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}

# [switch_to_java_11]
# This function will switch to java 11
function switch_to_java_11 {
	export JAVA_HOME="/usr/lib/jvm/java-11-openjdk-11.0.21.0.9-3.fc39.x86_64"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}