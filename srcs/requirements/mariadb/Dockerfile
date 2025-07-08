FROM debian:bullseye

# Install MariaDB server
RUN apt-get update && \
    apt-get install -y mariadb-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Initialize MariaDB data directory
RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

# Create run directory and set permissions
RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]