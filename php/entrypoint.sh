#!/bin/bash
set -e

echo "🚀 Iniciando Celeste..."

# Instalar dependencias PHP si no están instaladas
if [ ! -d "/var/www/html/vendor" ]; then
    echo "📦 Instalando dependencias con Composer..."
    cd /var/www/html
    composer install --no-interaction --prefer-dist --optimize-autoloader
    echo "✅ Composer listo"
else
    echo "✅ Dependencias ya instaladas"
fi

# Compilar assets si node_modules no existe
if [ ! -d "/var/www/html/node_modules" ]; then
    echo "🎨 Instalando dependencias Node y compilando assets..."
    cd /var/www/html
    npm install
    npm run build 2>/dev/null || echo "⚠️  Build de assets omitido (puede no ser necesario)"
    echo "✅ Assets listos"
else
    echo "✅ Assets ya compilados"
fi

# Permisos correctos
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "🌐 Levantando Apache..."
exec apache2-foreground
