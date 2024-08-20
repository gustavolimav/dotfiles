#!/bin/bash

# MARIADB

start_mariadb_container() {
    docker run --name mariadb-container -v $MARIADB_CONFIG_PATH/my.cnf:/etc/mysql/conf.d/my.cnf -p 3306:3306 -e MYSQL_ROOT_PASSWORD=$MARIADB_ROOT_PASSWORD -d mariadb
}

copy_dump_to_container_mariadb() {
    local dump_file_path=$1

    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} copy_dump_to_container_mariadb <dump_file_path> <container_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<dump_file_path>${NC}   Path to the SQL dump file to be copied"
        echo -e "  ${BLUE}<container_name>${NC}   Name of the Docker container running MySQL"
        return
    fi

    docker cp "$dump_file_path" mariadb-container:/dump.sql
}

create_database_mariadb() {
    local database_name=$1

    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} create_database_mariadb <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to create"
        return
    fi

    docker exec -i mariadb-container mariadb -u root -p"$MARIADB_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $database_name CHARACTER SET utf8 COLLATE utf8_general_ci;"
}

import_dump_mariadb() {
    local database_name=$1
    local dump_file_path=$2

    if [ "$1" == "help" ] || [ "$1" == "" ] || [ "$2" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} import_dump_mariadb <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to import the dump into"
        echo -e "  ${BLUE}<dump_file_path>${NC}   Path to the SQL dump file to be imported"
        return
    fi

    docker exec -i mariadb-container mariadb -u root -p"$MARIADB_ROOT_PASSWORD" "$database_name" < "$dump_file_path"
}

import_to_database_mariadb() {
    local dump_file_path=$1
    local database_name=$2

    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} import_to_database_mariadb <dump_file_path> <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<dump_file_path>${NC}   Path to the SQL dump file to be imported"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to import the dump into"
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

start_mysql_container() {
    docker run --name mysql-container -e MYSQL_ALLOW_EMPTY_PASSWORD=true -p 3306:3306 mysql:8.0.22
}

copy_dump_to_container_mysql() {
    local dump_file_path=$1

    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} copy_dump_to_container_mysql <dump_file_path>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<dump_file_path>${NC}   Path to the SQL dump file to be copied"
        return
    fi

    docker cp "$dump_file_path" mysql-container:/dump.sql
}

create_database_mysql() {
    local database_name=$1

    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} create_database_mysql <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to create"
        return
    fi

    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE IF NOT EXISTS $database_name;"
}

import_dump_mysql() {
    local database_name=$1
    local dump_file_path=$2

    if [ "$1" == "help" ] || [ "$1" == "" ] || [ "$2" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} import_dump_mysql <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to import the dump into"
        echo -e "  ${BLUE}<dump_file_path>${NC}   Path to the SQL dump file to be imported"
        return
    fi

    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" "$database_name" < "$dump_file_path"
}

import_to_database_mysql() {
    local dump_file_path=$1
    local database_name=$2

    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} import_to_database_mysql <dump_file_path> <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<dump_file_path>${NC}   Path to the SQL dump file to be imported"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to import the dump into"
        return
    fi

    copy_dump_to_container_mysql "$dump_file_path"
    create_database_mysql "$database_name"
    import_dump_mysql "$database_name"
}

list_db_mysql() {
    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "SHOW DATABASES;"
}

cdb_mysql() {
    if [ "$1" == "help" ] || [ "$1" == "" ]; then
        echo -e "${YELLOW}Usage:${NC} cdb_mysql <database_name>"
        echo ""
        echo -e "${YELLOW}Arguments:${NC}"
        echo -e "  ${BLUE}<database_name>${NC}    Name of the database to clean"
        return
    fi

    local name="$1"

    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "DROP DATABASE ${name}"
    docker exec -i mysql-container mysql -u root -p"$MYSQL_ROOT_PASSWORD" -e "CREATE DATABASE ${name} CHARACTER SET utf8 COLLATE utf8_general_ci;"
}