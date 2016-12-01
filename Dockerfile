FROM php:7.0-apache
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
        libxslt-dev \
        libicu-dev \
        git \
        mysql-client \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd bcmath pdo pdo_mysql xsl intl zip

RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2

COPY ./conf/auth.json /root/.composer/auth.json
COPY ./conf/.m2install.conf /var/www/.m2install.conf

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -o /usr/local/bin/m2install.sh https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install.sh && chmod +x /usr/local/bin/m2install.sh
