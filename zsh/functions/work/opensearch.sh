start-opensearch() {
    ant -f build-test-opensearch2.xml start-opensearch -Dopensearch.java.home/opt/java/jdk11
}

stop-opensearch() {
    ant -f build-test-opensearch2.xml stop-opensearch -Dopensearch.java.home/opt/java/jdk11
}