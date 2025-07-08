#!/bin/bash

# Wait for database to be ready
echo "Waiting for database connection..."
until mysqladmin ping -h"${WORDPRESS_DB_HOST}" --silent; do
    echo "Database not ready, waiting..."
    sleep 2
done
echo "Database is ready!"

# Change to WordPress directory
cd /var/www/html

# Download WordPress core if not already present
if [ ! -f "wp-config-sample.php" ]; then
    echo "Downloading WordPress with WP-CLI..."
    wp core download --allow-root
    echo "WordPress downloaded!"
fi

# Create wp-config.php if it doesn't exist
if [ ! -f "wp-config.php" ]; then
    echo "Creating wp-config.php with WP-CLI..."
    wp config create \
        --dbname="${WORDPRESS_DB_NAME}" \
        --dbuser="${WORDPRESS_DB_USER}" \
        --dbpass="${WORDPRESS_DB_PASSWORD}" \
        --dbhost="${WORDPRESS_DB_HOST}" \
        --allow-root
    echo "wp-config.php created!"
fi

# Install WordPress if not already installed
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install \
        --url="https://aprevrha.42.fr" \
        --title="Inception WordPress" \
        --admin_user="${WORDPRESS_ADMIN_USER}" \
        --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
        --admin_email="${WORDPRESS_ADMIN_EMAIL}" \
        --allow-root
    echo "WordPress installation completed!"
fi

# Create user if it doesn't exist
if ! wp user get "${WORDPRESS_USER}" --allow-root 2>/dev/null; then
    echo "Creating user: ${WORDPRESS_USER}..."
    wp user create \
        "${WORDPRESS_USER}" \
        "${WORDPRESS_USER_EMAIL}" \
        --user_pass="${WORDPRESS_USER_PASSWORD}" \
        --role=author \
        --allow-root
    echo "User created!"
fi

# Set proper permissions
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm7.4 -F
