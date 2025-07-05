FROM debian:bullseye

RUN apt-get update && \
    apt-get install -y php php-mysql php-fpm curl mariadb-client wget unzip && \
    apt-get clean

# Download WordPress
RUN mkdir -p /var/www/html && \
    curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html && \
    rm -rf latest.tar.gz wordpress

# Permissions
RUN chown -R www-data:www-data /var/www/html

# Configure PHP-FPM
RUN mkdir -p /run/php && \
    sed -i 's/listen = \/run\/php\/php7.4-fpm.sock/listen = 9000/' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;listen.owner = www-data/listen.owner = www-data/' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;listen.group = www-data/listen.group = www-data/' /etc/php/7.4/fpm/pool.d/www.conf && \
    sed -i 's/;listen.mode = 0660/listen.mode = 0660/' /etc/php/7.4/fpm/pool.d/www.conf

# Create WordPress config
COPY wp-config.php /var/www/html/

EXPOSE 9000

# Start PHP-FPM in foreground
CMD ["php-fpm7.4", "-F"]
