# [CLEAN DB]
# This function will clean the database
# Example: cdb <database name>
cdb() {
	emulate -LR bash
			password="L1f3ray#"

			if [ "$1" == "" ]; then
				echo "ERROR: You must specify a database name (help / <database name>)" 
				return
			fi

			if [ "$1" == "help" ]; then
				echo "cdb <database name>"
				return
			fi

			if [ "$1" == "" ]; then
				echo "cdb <database name>"
				return
			else
				name="$1"

				dropDB $name

				createDB $name
			fi
}

dropDB() {
	emulate -LR bash
			password="L1f3ray#"

			if [ "$1" == "" ]; then
				echo "ERROR: You must specify a database name (help / <database name>)" 
				return
			fi

			if [ "$1" == "help" ]; then
				echo "dropDB <database name>"
				return
			fi

			if [ "$1" == "" ]; then
				echo "dropDB <database name>"
				return
			else
				name="$1"

				mysql -u root -p$password -e "DROP DATABASE ${name}"
			fi

}

createDB() {
	emulate -LR bash
			password="L1f3ray#"

			if [ "$1" == "" ]; then
				echo "ERROR: You must specify a database name (help / <database name>)" 
				return
			fi

			if [ "$1" == "help" ]; then
				echo "createDB <database name>"
				return
			fi

			if [ "$1" == "" ]; then
				echo "createDB <database name>"
				return
			else
				name="$1"

				mysql -u root -p$password -e "CREATE DATABASE ${name} character set UTF8 collate utf8_general_ci;"
			fi


}

# [DUMP DB]
# Function to export or import a database
# Example: dump <import/export> <database name> <dump name>
dump() {
	emulate -LR bash
		password="L1f3ray#"

		if [ "$1" == "" ]; then
			echo "ERROR: You must specify an action (import / export / help / list / clear)" 
			return
		fi

		if [ "$1" == "help" ]; then
			echo "dump import <database name> <dump name>"
			echo "dump export <database name> <dump name>"
			echo "dump list"
			echo "dump help"
			echo "dump clear"
			return
		fi

		if [ "$1" == "list" ]; then
			ls /home/me/dumps
			return
		fi

		if [ "$1" == "clear" ]; then
			rm -rf /home/me/dumps/*
			return
		fi

		if [ "$2" != "" ]; then
			dbName="$2"
		else
			echo "ERROR: You must specify a database name" 
		fi

		if [ "$3" != "" ]; then
			dumpName="/home/me/dumps/${3}.sql"
		else
			echo "ERROR: You must specify a dump name" 
		fi

		if [ "$1" == "export" ]; then
			mysqldump -u root -p${password} ${dbName} > ${dumpName}
		elif [ "$1" == "import" ]; then
			mysql -u root -p${password} ${dbName} < ${dumpName}
		fi
}