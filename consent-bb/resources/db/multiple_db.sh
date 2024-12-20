#!/bin/bash

set -e
set -u

echo "SETTING UP NEW USERS"

function create_user_and_database() {
	local database=$1
	echo "  Creating user and database '$database'"
	PGPASSWORD=$POSTGRESQL_POSTGRES_PASSWORD psql -v ON_ERROR_STOP=1 --username "postgres" <<-EOSQL
	    CREATE USER $database;
	    CREATE DATABASE $database;
	    GRANT ALL PRIVILEGES ON DATABASE $database TO $database;
EOSQL
}

if [ -n "$POSTGRES_MULTIPLE_DATABASES" ]; then
	echo "Multiple database creation requested: $POSTGRES_MULTIPLE_DATABASES"
	for db in $(echo $POSTGRES_MULTIPLE_DATABASES | tr ',' ' '); do
		create_user_and_database $db
	done
	echo "Multiple databases created"
fi