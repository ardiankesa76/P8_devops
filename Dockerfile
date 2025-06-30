# Gunakan image PHP-FPM resmi sebagai base image
FROM php:8.1-apache

# Set working directory di dalam container
WORKDIR /var/www/html

# Install composer
# Menggunakan stage khusus dari image composer:latest untuk mendapatkan binary composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy composer.json dan composer.lock terlebih dahulu
COPY composer.json composer.lock ./

# Install dependencies (hanya dependensi produksi, bukan dev)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Copy semua file aplikasi lainnya
COPY . .

# Exposed port 80 untuk Apache (port default server web)
EXPOSE 80

# Perintah default untuk menjalankan Apache saat container dimulai
CMD ["apache2-foreground"]