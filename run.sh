#!/bin/bash
if [ -f /.mysql_db_created ]; 
then
        exec supervisord -n
        exit 1
fi

sleep 5
DB_EXISTS=$(mysql -uroot -p$DB_PASSWORD -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e "SHOW DATABASES LIKE 'wordpress';" | grep "wordpress" > /dev/null; echo "$?")

if [[ DB_EXISTS -eq 1 ]]; 
then
        echo "=> Creating database wordpress"
        RET=1
        while [[ RET -ne 0 ]]; do
                sleep 5
                mysql -uroot -p$DB_PASSWORD -h$DB_1_PORT_3306_TCP_ADDR -P$DB_1_PORT_3306_TCP_PORT -e "CREATE DATABASE $DB_NAME"
                RET=$?
        done
        echo "=> Done!"
else
        echo "=> Skipped creation of database wordpress – it already exists."
fi

touch /.mysql_db_created
exec supervisord -n
