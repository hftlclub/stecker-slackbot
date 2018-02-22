#!/bin/bash

set -e

: ${MYSQL_ROOT:=root}
: ${MYSQL_TABLE:=store}

# Check if database already exists
RESULT=`mysql -h${MYSQL_DB_HOST} -u${MYSQL_ROOT} -p${DBROOT} --skip-column-names \
    -e "SHOW DATABASES LIKE '${DBNAME}';"`

if [ "$RESULT" != "$DBNAME" ]; then
    # mysql database does not exist, create it
    echo "Creating database ${DBNAME}"
    mysql -h${MYSQL_DB_HOST} -u${MYSQL_ROOT} -p${DBROOT} \
        -e "CREATE DATABASE ${DBNAME};"
fi

# Check if table already exists
TABLERESULT=`mysql -h${MYSQL_DB_HOST} -u${MYSQL_ROOT} -p${DBROOT} \
    -h${MYSQL_DB_HOST} --skip-column-names \
    -e "USE '${DBNAME}';
    SHOW TABLES LIKE 'store';"`

if [ "$TABLERESULT" != "$MYSQL_TABLE" ]; then
    # mysql database does not exist, create it
    echo "Creating table ${MYSQL_TABLE}"
    mysql -h${MYSQL_DB_HOST} -u${MYSQL_ROOT} -p${DBROOT} ${DBNAME} \
        -e "CREATE TABLE IF NOT EXISTS \`store\` (
        \`key\` varchar(100) COLLATE utf8mb4_bin NOT NULL DEFAULT '',
        \`value\` longtext COLLATE utf8mb4_bin NOT NULL,
        PRIMARY KEY (\`key\`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;"

    echo "Grant privileges to user ${DBUSER} on database ${DBNAME}"
    mysql -h${MYSQL_DB_HOST} -u${MYSQL_ROOT} -p${DBROOT} \
        -e "GRANT ALL PRIVILEGES ON ${DBNAME}.* TO '${DBUSER}'@'%' WITH GRANT OPTION;
        FLUSH PRIVILEGES;"
fi

echo "Database initialization complete"

/home/node/steckerbot/settings/modify_settings.sh

exec "$@"

