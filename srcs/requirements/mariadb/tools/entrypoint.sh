#!/bin/bash

# Check if this is first setup
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    echo "Setting up database..."
    
    # Start MariaDB temporarily in safe mode (skip authentication)
    mysqld_safe --skip-networking --skip-grant-tables &
    PID=$!

    # Wait for MariaDB to be ready
    until mysqladmin ping &>/dev/null; do
        echo "Waiting for MariaDB to start..."
        sleep 1
    done
    echo "MariaDB is ready!"

    # Create database and user
    mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Stop temporary MariaDB properly
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    wait $PID
    echo "Temporary MariaDB stopped"
else
    echo "Database already initialized, skipping setup."
fi

# Start MariaDB normally
echo "Starting MariaDB..."
exec mysqld --user=mysql --bind-address=0.0.0.0
