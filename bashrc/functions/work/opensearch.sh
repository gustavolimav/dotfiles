start-opensearch() {
    ant -f build-test-opensearch2.xml start-opensearch -Dopensearch.java.home=/opt/java/jdk11
}

stop-opensearch() {
    ant -f build-test-opensearch2.xml stop-opensearch -Dopensearch.java.home=/opt/java/jdk11
}

gwt_opensearch() {
    if [ "$1" == "" ]; then
		gw test -Dcom.liferay.portal.search.opensearch2.test.unit.enabled=true
		return
	fi

    if [ "$2" == "-d" ]; then
		gw test --tests "$1" -Dcom.liferay.portal.search.opensearch2.test.unit.enabled=true --debug-jvm
		return
	fi

    gw test --tests "$1" -Dcom.liferay.portal.search.opensearch2.test.unit.enabled=true
}