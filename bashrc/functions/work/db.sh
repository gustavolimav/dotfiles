#MARIADB

export MARIADB_ROOT_PASSWORD='my-secret-pw'
export MARIADB_CONFIG_PATH='~/mariadb-config'

tldr_mariadb() {
    echo "start_mariadb_container <container_name>"
    echo "copy_dump_to_container_mariadb <dump_file_path>"
    echo "create_database_mariadb <database_name>"
    echo "import_dump_mariadb <database_name>"
    echo "import_to_database_mariadb <dump_file_path> <database_name>"
}

start_mariadb_container() {
    docker run --name mariadb-container -v $MARIADB_CONFIG_PATH/my.cnf:/etc/mysql/conf.d/my.cnf -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD -d mariadb
}

copy_dump_to_container_mariadb() {
    local dump_file_path=$1

    if [ "$1" == "--help" ]; then
        echo "Usage: copy_dump_to_container_mariadb <dump_file_path> <container_name>"
        echo ""
        echo "Arguments:"
        echo "  <dump_file_path>   Path to the SQL dump file to be copied"
        echo "  <container_name>   Name of the Docker container running MySQL"
        return
    fi

    if [ "$1" == "" ]; then
        echo "ERROR: Must specify the path to the SQL dump file to be copied"
        return
    fi

    docker cp "$dump_file_path" mariadb-container:/dump.sql
}

create_database_mariadb() {
    local database_name=$1

    if [ "$1" == "--help" ]; then
        echo "Usage: create_database_mariadb <database_name>"
        echo ""
        echo "Arguments:"
        echo "  <database_name>    Name of the database to create"
        return
    fi

    if [ "$1" == "" ]; then
        echo "ERROR: Must specify the name of the database to create"
        return
    fi

    docker exec -i mariadb-container mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $database_name CHARACTER SET utf8 COLLATE utf8_general_ci;"
}

import_dump_mariadb() {
    local database_name=$1

     if [ "$1" == "--help" ]; then
        echo "Usage: import_dump_mariadb <database_name>"
        echo ""
        echo "Arguments:"
        echo "  <database_name>    Name of the database to import the dump into"
        return
    fi

    if [ "$1" == "" ]; then
        echo "ERROR: Must specify the name of the database to import the dump into"
        return
    fi

    docker exec -i mariadb-container mariadb -u root -p"$MARIADB_ROOT_PASSWORD" "$database_name" < /dump.sql
}

import_to_database_mariadb() {
    local dump_file_path=$1
    local database_name=$2

    if [ "$1" == "--help" ]; then
        echo "Usage: import_to_database_mysql <dump_file_path> <database_name>"
        echo ""
        echo "Arguments:"
        echo "  <dump_file_path>   Path to the SQL dump file to be imported"
        echo "  <database_name>    Name of the database to import the dump into"
        return
    fi

    if [ "$1" == "" ]; then
        echo "ERROR: Must specify the path to the SQL dump file to be imported"
        return
    fi

    if [ "$2" == "" ]; then
        echo "ERROR: Must specify the name of the database to import the dump into"
        return
    fi

    copy_dump_to_container_mariadb "$dump_file_path"
    create_database_mariadb "$database_name"
    import_dump_mariadb "$database_name"
}

list_db_mariadb() {
    docker exec -i mariadb-container mariadb -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"
}

# MYSQL

export MYSQL_ROOT_PASSWORD='my-secret-pw'
export MYSQL_CONFIG_PATH='~/mysql-config'

tldr_mysql() {
    echo "start_mysql_container"
    echo "copy_dump_to_container_mysql <dump_file_path>"
    echo "create_database_mysql <database_name>"
    echo "import_dump_mysql <database_name>"
    echo "import_to_database_mysql <dump_file_path> <database_name>"
}

start_mysql_container() {
    docker run --name mysql-container -v "$MYSQL_CONFIG_PATH/my.cnf:/etc/mysql/conf.d/my.cnf" -p 3306:3306 -e MYSQL_ROOT_PASSWORD="$MYSQL_ROOT_PASSWORD" -d mysql
}

copy_dump_to_container_mysql() {
    local dump_file_path=$1

    if [ "$1" == "--help" ]; then
        echo "Usage: copy_dump_to_container_mysql <dump_file_path>"
        echo ""
        echo "Arguments:"
        echo "  <dump_file_path>   Path to the SQL dump file to be copied"
        return
    fi

    docker cp "$dump_file_path" mysql-container:/dump.sql
}

create_database_mysql() {
    local database_name=$1

    if [ "$1" == "--help" ]; then
        echo "Usage: create_database_mysql <database_name>"
        echo ""
        echo "Arguments:"
        echo "  <database_name>    Name of the database to create"
        return
    fi

    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $database_name;"
}

import_dump_mysql() {
    local database_name=$1

    if [ "$1" == "--help" ]; then
        echo "Usage: import_dump_mysql <database_name>"
        echo ""
        echo "Arguments:"
        echo "  <database_name>    Name of the database to import the dump into"
        return
    fi

    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$database_name" < /dump.sql
}

import_to_database_mysql() {
    local dump_file_path=$1
    local database_name=$2

     if [ "$1" == "--help" ]; then
        echo "Usage: import_to_database_mysql <dump_file_path> <database_name>"
        echo ""
        echo "Arguments:"
        echo "  <dump_file_path>   Path to the SQL dump file to be imported"
        echo "  <database_name>    Name of the database to import the dump into"
        return
    fi

    copy_dump_to_container_mysql "$dump_file_path"
    create_database_mysql "$database_name"
    import_dump_mysql "$database_name"
}

list_db_mysql() {
    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"
}

# [CLEAN DB]
# This function will clean the database
# Example: cdb <database name>
cdb_mysql() {

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

		mysql -u root -p$DB_PASSWORD -e "DROP DATABASE ${name}"

		mysql -u root -p$DB_PASSWORD -e "CREATE DATABASE ${name} character set UTF8 collate utf8_general_ci;"
	 fi
}