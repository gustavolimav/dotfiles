# [BUNDLE CREATION - BRANCHES ONLY]
# This function will create a bundle with the same name as the branch you are on
# If you want to create a bundle with a custom name you can pass it as a parameter
# Example: createBundle myBundle
createBundle(){
	emulate -LR bash
       	if [[ $1 == "" ]]
				then
					name=$(git branch --show-current)
				else
					name=$1
				fi

				if [[ $name == "" ]]
				then
					echo "ERROR RUNNING COMMAND: Please pass a parameter"
				else
					echo "app.server.parent.dir=/home/$USER/dev/projects/bundles/${name}" > app.server.$USER.properties
					cp $PROPERTIES_FILE_PATH/build.$USER.properties .
					ant setup-sdk compile install-portal-snapshots && cd modules/core/portal-bootstrap && gw bSPEM deploy && cd -
					ant setup-profile-dxp
					ant all
					echo "The new bundle was created in ~/dev/projects/bundles/${name}"
				fi
}

# [RUN TOMCAT WITH DEBUGGER ON ANY BUNDLE FOLDER]
# This function will run the last version of tomcat with the debugger on
# inside the bundle folder you are on
run(){
	emulate -LR bash
			tomcatfile=$(find . -name 'tomcat*' -type d | sort -r | head -n 1)
			if [[ $tomcatfile == "" ]]; then
				previousdirectory="../"
				for i in {1..5}; do
						tomcatfile=$(find ${previousdirectory} -name 'tomcat-*' -type d | sort -r | head -n 1)
					if [[ $tomcatfile == "" ]]; then previousdirectory="${previousdirectory}../"; else break; fi
				done
			fi
			if [[ $tomcatfile == "" ]]; then echo "ERROR RUNNING COMMAND: check if the command was run inside a bundle"; 
			else ./$tomcatfile/bin/catalina.sh jpda run; fi
}

# [SET PROPS TO PORTAL-SETUP-WIZARD.PROPERTIES]
# This function will set the properties to portal-setup-wizard.properties
# inside the bundle folder you are on
setprop(){
	emulate -LR bash
			home=$(pwd)
			echo "admin.email.from.address=test@liferay.com" > portal-setup-wizard.properties
			echo "admin.email.from.name=Test Test" >> portal-setup-wizard.properties
			echo "company.default.locale=en_US" >> portal-setup-wizard.properties
			echo "company.default.time.zone=UTC" >> portal-setup-wizard.properties
			echo "company.default.web.id=liferay.com" >> portal-setup-wizard.properties
			echo "default.admin.email.address.prefix=test" >> portal-setup-wizard.properties
			echo "liferay.home=${home}" >> portal-setup-wizard.properties

			echo "setup.wizard.enabled=false" >> portal-setup-wizard.properties
			echo "company.security.strangers.verify=false" >> portal-setup-wizard.properties
			echo "terms.of.use.required=false" >> portal-setup-wizard.properties
			echo "passwords.default.policy.change.required=false" >> portal-setup-wizard.properties
			echo "users.reminder.queries.enabled=false" >> portal-setup-wizard.properties
			echo "users.reminder.queries.custom.question.enabled=false" >> portal-setup-wizard.properties

			echo "mail.send.blacklist=" >> portal-setup-wizard.properties
			echo "mail.session.mail=false" >> portal-setup-wizard.properties
			echo "mail.session.mail.pop3.host=localhost" >> portal-setup-wizard.properties
			echo "mail.session.mail.pop3.password=" >> portal-setup-wizard.properties
			echo "mail.session.mail.pop3.port=110" >> portal-setup-wizard.properties
			echo "mail.session.mail.pop3.user=" >> portal-setup-wizard.properties
			echo "mail.session.mail.smtp.auth=false" >> portal-setup-wizard.properties
			echo "mail.session.mail.smtp.host=localhost" >> portal-setup-wizard.properties
			echo "mail.session.mail.smtp.password=" >> portal-setup-wizard.properties
			echo "mail.session.mail.smtp.port=3333" >> portal-setup-wizard.properties
			echo "mail.session.mail.smtp.user=" >> portal-setup-wizard.properties
			echo "mail.session.mail.store.protocol=pop3" >> portal-setup-wizard.properties
			echo "mail.session.mail.transport.protocol=smtp" >> portal-setup-wizard.properties

			echo "monitoring.level.com.liferay.monitoring.Portal=HIGH" >> portal-setup-wizard.properties
			echo "monitoring.level.com.liferay.monitoring.Portlet=HIGH" >> portal-setup-wizard.properties
			echo "monitoring.portal.request=true" >> portal-setup-wizard.properties
			echo "monitoring.portlet.action.request=true" >> portal-setup-wizard.properties
			echo "monitoring.portlet.event.request=true" >> portal-setup-wizard.properties
			echo "monitoring.portlet.render.request=true" >> portal-setup-wizard.properties
			echo "monitoring.portlet.resource.request=true" >> portal-setup-wizard.properties
			echo "monitoring.show.per.request.data.sample=true" >> portal-setup-wizard.properties

			echo "com.liferay.portal.servlet.filters.cache.CacheFilter=false" >> portal-setup-wizard.properties
			echo "com.liferay.portal.servlet.filters.etag.ETagFilter=false" >> portal-setup-wizard.properties
			echo "com.liferay.portal.servlet.filters.header.HeaderFilter=false" >> portal-setup-wizard.properties
			echo "com.liferay.portal.servlet.filters.themepreview.ThemePreviewFilter=true" >> portal-setup-wizard.properties
			echo "theme.css.fast.load=false" >> portal-setup-wizard.properties
			echo "theme.css.fast.load.check.request.parameter=true" >> portal-setup-wizard.properties
			echo "theme.images.fast.load=false" >> portal-setup-wizard.properties
			echo "theme.images.fast.load.check.request.parameter=true" >> portal-setup-wizard.properties
			echo "minifier.enabled=false" >> portal-setup-wizard.properties
			echo "javascript.fast.load=false" >> portal-setup-wizard.properties
			echo "javascript.log.enabled=false" >> portal-setup-wizard.properties
			echo "feature.flag.ui.visible[dev]=true" >> portal-setup-wizard.properties

			if [[ $1 == "db" ]]; then
				echo "Aupgrade.database.auto.run=true" >> portal-setup-wizard.properties
				echo "database.indexes.update.on.startup=true" >> portal-setup-wizard.properties
				echo "jdbc.default.driverClassName=com.mysql.cj.jdbc.Driver" >> portal-setup-wizard.properties
				echo "jdbc.default.password=L1f3ray#" >> portal-setup-wizard.properties
				echo "jdbc.default.username=root" >> portal-setup-wizard.properties

				# Get the current directory path
				current_dir="$(pwd)"

				# Use 'basename' to extract the directory name
				dir_name="$(basename "$current_dir")"

				# Replace hyphens with underscores using 'sed'
				dir_name="${dir_name//-/_}"

				# Replace dot with underscores using 'sed'
				dir_name="${dir_name//./_}"

				db_name="lportal_${dir_name}"

				cdb ${db_name}

				echo "jdbc.default.url=jdbc:mysql://localhost/${db_name}?useUnicode=true&characterEncoding=UTF-8&useFastDateParsing=false" >> portal-setup-wizard.properties
			fi

}