FROM php:8.3-apache

# Instalar dependencias del sistema y extensiones PHP
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libwebp-dev libfreetype6-dev \
    libzip-dev libicu-dev libxml2-dev libcurl4-openssl-dev \
    unzip wget git curl nodejs npm && \
    docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp && \
    docker-php-ext-install \
    gd pdo pdo_mysql mysqli curl intl mbstring xml zip bcmath soap

# Instalar Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Configuración PHP para PrestaShop
RUN echo "memory_limit = 256M\nupload_max_filesize = 64M\npost_max_size = 64M\nmax_execution_time = 300" \
    > /usr/local/etc/php/conf.d/prestashop.ini

WORKDIR /var/www/html

# Script de arranque
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]