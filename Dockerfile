FROM clevyr/prestissimo:latest AS composer

COPY . /app

RUN composer install

FROM php:7.2-apache

RUN a2dismod status
RUN a2dismod userdir

RUN a2enmod rewrite

RUN docker-php-ext-install pdo pdo_mysql

COPY --from=composer /app /var/www/html/

ENV APACHE_DOCUMENT_ROOT /var/www/html/public_html

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
