# [switch_to_java_7]
# This function will switch to java 7
function switch_to_java_7 {
	emulate -LR bash
	
			export JAVA_HOME="/opt/java/jdk7"

			export PATH="${JAVA_HOME}/bin:${PATH}"
}

# [switch_to_java_8]
# This function will switch to java 8
function switch_to_java18 {
  emulate -LR bash
	export JAVA_HOME="/opt/java/jdk18"

	export PATH="${JAVA_HOME}/bin:${PATH}"
}