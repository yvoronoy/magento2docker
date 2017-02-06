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
        pv \
        vim \
        bash-completion \
        openssh-server \
        ssl-cert \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd bcmath pdo pdo_mysql xsl intl zip

RUN pecl install xdebug
RUN echo ";zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_host=10.254.254.254" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN a2enmod ssl
RUN a2ensite default-ssl.conf

RUN a2enmod rewrite
RUN chown -R www-data:www-data /var/www/html
ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_LOG_DIR /var/log/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_PID_FILE /var/run/apache2.pid

COPY ./etc/composer/auth.json /root/.composer/auth.json
COPY ./etc/ssh /root/.ssh
ADD ./etc/ssh/magento2docker.pub /root/.ssh/authorized_keys
RUN chmod -R 400 /root/.ssh
COPY ./etc/fixtures /etc/fixtures
COPY ./etc/m2install/m2install.conf /root/.m2install.conf
COPY ./misc/xdebug-php.sh /usr/local/bin/xdebug-php.sh

RUN chmod +x /usr/local/bin/xdebug-php.sh
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN curl -o /usr/local/bin/m2install.sh https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install.sh \
    && chmod +x /usr/local/bin/m2install.sh
RUN curl -o /usr/local/bin/n98-magerun2 https://files.magerun.net/n98-magerun2.phar \
    && chmod +x /usr/local/bin/n98-magerun2
RUN curl -o /usr/local/bin/m2-convert-for-composer https://raw.githubusercontent.com/isitnikov/m2-convert-patch-for-composer-install/master/convert-for-composer.php \
    && chmod +x /usr/local/bin/m2-convert-for-composer
RUN curl -o /etc/bash_completion.d/magento2-bash-completion https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion-enterprise
RUN echo "source /etc/bash_completion" >> /root/.bashrc

CMD service ssh start; apache2-foreground
