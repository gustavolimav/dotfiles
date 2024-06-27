# [SOLR]
# This function will start solr with the version you choose
# You can choose the version of the solr server and the version of the portal
function solr() {
	version="
	master-8.6.2
	7.3.x-8.6.2
	7.2.x-8.6.2
	7.2.x-7.5.0
	7.1.x-8.6.2
	7.1.x-7.5.0
	7.0.x-5.2.1"

	select choice in $version; do
		if [ "$choice" == "master-8.6.2" ]; then
			start-solr 8.6.2 8983 8 ""
		elif [ "$choice" == "7.3.x-8.6.2" ]; then
			start-solr 8.6.2 8983 8 "-7.3.x"
		elif [ "$choice" == "7.2.x-8.6.2" ]; then
			start-solr 8.6.2 8983 8 "-7.2.x"
		elif [ "$choice" == "7.2.x-7.5.0" ]; then
			start-solr 7.5.0 8983 7 "-7.2.x"
		elif [ "$choice" == "7.1.x-8.6.2" ]; then
			start-solr 8.6.2 8983 8 "-7.1.x"
		elif [ "$choice" == "7.1.x-7.5.0" ]; then
			start-solr 7.5.0 8983 7 "-7.1.x"
		elif [ "$choice" == "7.0.x-5.2.1" ]; then
			start-solr 5.2.1 8983 5 "-7.0.x"
		fi
		break
	done
}

# [START SOLR]
# This function will start solr with the version you choose
# You can choose the version of the solr server and the version of the portal
function start-solr() {
	solrServerSuffix="$1"
	portNumber="$2"
	solrVersion="$3"
	portalVersion="$4"

	if [ "$1" == "help" ]; then
		echo "Usage: start-solr [solrServerSuffix] [portNumber] [solrVersion] [portalVersion]"
		echo "Example: start-solr 8.6.2 8983 8"
		echo "Example: start-solr 8.6.2 8983 8 -7.3.x"
		echo "Example: start-solr 8.6.2 8983 8 -7.2.x"
		echo "Example: start-solr 7.5.0 8983 7 -7.2.x"
		echo "Example: start-solr 8.6.2 8983 8 -7.1.x"
		echo "Example: start-solr 7.5.0 8983 7 -7.1.x"
		echo "Example: start-solr 5.2.1 8983 5 -7.0.x"
		return
	fi

	read -ep "Delete old index? (y):" deleteOldIndex

	if [ "$deleteOldIndex" != "n" ]; then
		rm -rf ~/solr/solr-$solrServerSuffix/server/solr/liferay/data
	fi
	
	echo "Copying schema.xml, managed-schema.xml and solrconfig.xml..."

	if [ "$solrVersion" == "5" ]; then
		cp ~/dev/projects/liferay-portal$portalVersion/modules/apps/portal-search-solr/portal-search-solr/src/main/resources/META-INF/resources/schema.xml ~/solr/solr-$solrServerSuffix/server/solr/liferay/conf
		cp ~/dev/projects/liferay-portal$portalVersion/modules/apps/portal-search-solr/portal-search-solr/src/main/resources/META-INF/resources/solrconfig.xml ~/solr/solr-$solrServerSuffix/server/solr/liferay/conf
	else
		# cp ~/dev/projects/liferay-portal$portalVersion/modules/apps/portal-search-solr$solrVersion/portal-search-solr$solrVersion-impl/src/main/resources/META-INF/resources/managed-schema.xml ~/solr/solr-$solrServerSuffix/solr/server/solr/liferay/conf
		cp /home/me/solr/solr-8.6.2/server/solr/configsets/_default/conf/* -r ~/solr/solr-$solrServerSuffix/server/solr/liferay/conf
		cp ~/dev/projects/liferay-portal$portalVersion/modules/apps/portal-search-solr$solrVersion/portal-search-solr$solrVersion-impl/src/main/resources/META-INF/resources/schema.xml ~/solr/solr-$solrServerSuffix/server/solr/liferay/conf
		cp ~/dev/projects/liferay-portal$portalVersion/modules/apps/portal-search-solr$solrVersion/portal-search-solr$solrVersion-impl/src/main/resources/META-INF/resources/solrconfig.xml ~/solr/solr-$solrServerSuffix/server/solr/liferay/conf
	fi
	
	cd ~/solr/solr-$solrServerSuffix/bin
	./solr start -f -p $portNumber
}