FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y php php-mysql php-fpm curl mariadb-client wget unzip && \
    apt-get clean

# Install WP-CLI
RUN curl -L https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -o wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

# Create WordPress directory
RUN mkdir -p /var/www/html

# Create PHP-FPM run directory
RUN mkdir -p /run/php

# Configure PHP-FPM
COPY conf/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Copy entrypoint script
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 9000

# Use entrypoint script
ENTRYPOINT ["/entrypoint.sh"]
