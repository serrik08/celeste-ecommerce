#!/bin/sh
set -e

if [ ! -f "/var/www/html/composer.json" ]; then
  echo "No se encontro composer.json"
elif [ ! -f "/var/www/html/vendor/autoload.php" ]; then
  echo "Instalando dependencias Composer..."
  cd /var/www/html
  composer install --no-interaction --prefer-dist --optimize-autoloader
  echo "Composer listo"
else
  echo "Dependencias PHP ya instaladas"
fi

if [ -f "/var/www/html/package.json" ] && [ ! -d "/var/www/html/node_modules" ]; then
  echo "Compilando assets Node..."
  cd /var/www/html
  npm install
  npm run build 2>/dev/null || echo "Build de assets omitido"
else
  echo "Paso Node omitido"
fi

chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "Levantando Apache..."
exec apache2-foreground
