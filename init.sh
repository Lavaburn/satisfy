#!/bin/sh

# Copy code to empty dir
cp -a /var/www/html/. /mnt/

# Copy configuration from mounted files
# Symfony 6 no longer reads parameters.yml: services_prod.yaml overrides services.yaml
cp /config/parameters.yml /mnt/config/services_prod.yaml
cp /config/satis.json /mnt/satis.json
cp /config/auth.json /root/.composer/auth.json

mkdir -p /mnt/var/composer

# Fix permissions
chgrp -R www-data /mnt
chmod 775 /mnt
chown -R www-data /mnt/var
chmod 777 /mnt/var/*
chmod 775 /mnt/public
chmod 666 /mnt/satis.json

chmod 755 /root
chmod 777 /root/.composer

# First Satis build
cd /mnt
bin/satis build satis.json web

# Web UI / webhook rebuilds run as www-data
chown -R www-data /mnt/public
