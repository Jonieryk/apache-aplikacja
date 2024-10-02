# Use the Debian Bullseye Slim as the base image
FROM debian:bullseye-slim

# Install Apache, PHP, and other required packages
RUN apt-get update && apt-get install -y \
    apache2 \
    php \
    libapache2-mod-php \
    curl
#Clean up the install to save on size of the container
RUN    apt-get clean
RUN    rm -rf /var/lib/apt/lists/*

# Copy the Apache virtual host configuration
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf

# Copy the PHP file to the web root directory
COPY index.php /var/www/html/index.php
COPY index.html /var/www/html/index.html

# Set permissions for the web root
RUN chown -R www-data:www-data /var/www/html

# Expose port 80
EXPOSE 80

# Enable necessary Apache modules
RUN a2enmod php7.4

# Start Apache in the foreground
CMD ["apachectl", "-D", "FOREGROUND"]

# Health check: use apachectl to check if Apache is running correctly
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s CMD apachectl -k graceful || exit 1
