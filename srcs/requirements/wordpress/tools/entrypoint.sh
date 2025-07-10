#!/bin/bash

until mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
    echo "Waiting for database..."
    sleep 2
done

cd /var/www/html

if [ ! -f "wp-config-sample.php" ]; then
    wp core download --allow-root
fi

if [ ! -f "wp-config.php" ]; then
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root
fi

if ! wp core is-installed --allow-root 2>/dev/null; then
    wp core install \
        --url="https://aprevrha.42.fr" \
        --title="Inception WordPress" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --allow-root
    
    wp user create \
        "${WORDPRESS_USER}" \
        "${WORDPRESS_USER_EMAIL}" \
        --user_pass="${WORDPRESS_USER_PASSWORD}" \
        --role=editor \
        --allow-root
    
    echo "WordPress setup completed!"
else
    echo "WordPress is already installed."
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
