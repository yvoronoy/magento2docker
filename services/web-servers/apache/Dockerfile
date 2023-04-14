ARG M2D_WEB_SERVER_PHP_VERSION='8.1'
ARG M2D_ENABLE_BLACKFIRE='no'
ARG M2D_ENABLE_MAILCATCHER='no'

## BASE PHP IMAGE - COMMON FOR ALL PHP VERSIONS ##
FROM php:${M2D_WEB_SERVER_PHP_VERSION}-apache-bullseye AS m2d_web_server_apache_php_base

# SETTING UP THE SYSTEM:
RUN apt-get update \
    && apt-get install -y \
        apt-utils \
        wget \
        libwebp-dev \
        libxpm-dev \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxslt-dev \
        libicu-dev \
        mariadb-client \
        pv \
        vim \
        nano \ 
        bash-completion \
        openssh-server \
        ssl-cert \
        sudo \
        dnsutils \
        iputils-ping \
        iputils-tracepath \
        host \
        strace \
        telnet \
        unzip \
        gnupg \
        gcc \
        lsof \
        libsodium-dev \
        libzip-dev \
        parallel \
        git \
    && apt-get update \
    && apt-get clean all

# CREATE USER:
ENV _USER=magento
ENV _HOME_DIRECTORY=/home/${_USER}
RUN useradd -m ${_USER} && echo "${_USER}:${_USER}" | chpasswd && chsh ${_USER} -s /bin/bash && adduser ${_USER} sudo

# COMMON PHP EXTENSIONS:
RUN docker-php-ext-install -j$(nproc) iconv soap sockets \
    && docker-php-ext-install -j$(nproc) bcmath pdo_mysql xsl intl zip

# PHP CONFIG FILES:
ARG M2D_WEB_SERVER_PHP_MEMORY_LIMIT='2G'
ENV M2D_WEB_SERVER_PHP_MEMORY_LIMIT=${M2D_WEB_SERVER_PHP_MEMORY_LIMIT}
COPY ./services/web-servers/apache/etc/php/* /usr/local/etc/php/conf.d/

# NODEJS:
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get install -y nodejs

# INSTALL COMPOSER 1 AND COMPOSER 2:
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer1 --1 \
    && apt -qy install $PHPIZE_DEPS && mkdir /${_HOME_DIRECTORY}/.composer \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer2 --2

# TOOLS:
COPY ./services/web-servers/apache/tools/* /usr/local/bin/

# CUSTOM CONFIGURATIONS:
COPY ./services/web-servers/apache/etc/apache2 /etc/apache2
COPY ./services/web-servers/apache/etc/fixtures /etc/fixtures

# SSH:
COPY ./services/web-servers/apache/etc/ssh ${_HOME_DIRECTORY}/.ssh
ADD ./services/web-servers/apache/etc/ssh/magento2docker.pub ${_HOME_DIRECTORY}/.ssh/authorized_keys
RUN chmod -R 700 ${_HOME_DIRECTORY}/.ssh \
    && echo "    ServerAliveInterval 30" >> /etc/ssh/ssh_config \
    && echo "    TCPKeepAlive yes" >> /etc/ssh/ssh_config
COPY ./services/web-servers/apache/etc/ssh /root/.ssh
ADD ./services/web-servers/apache/etc/ssh/magento2docker.pub /root/.ssh/authorized_keys
RUN chmod -R 700 /root/.ssh \
    && echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-cbc,3des-cbc,aes192-cbc,aes256-cbc" >> /etc/ssh/sshd_config \
    && touch /root/.ssh/known_hosts \
    && ssh-keygen -F github.com || ssh-keyscan github.com >> /root/.ssh/known_hosts

# APACHE:
RUN a2enmod ssl \
    && a2ensite default-ssl.conf \
    && a2enmod vhost_alias \
    && a2enmod proxy \
    && a2enmod rewrite \
    && chown -R ${_USER}:${_USER} /var/www/html
RUN chown -R ${_USER}:${_USER} ${_HOME_DIRECTORY}

# TUNE ENVIRONMENT:
RUN echo "Defaults    timestamp_timeout=-1" >> /etc/sudoers

# FLAG TO NOT CACHE ANYTHING FROM THIS POINT, details: https://github.com/docker/docker/issues/1996#issuecomment-185872769
ARG CACHEBUST=1

# MAGENTO TOOLS:
RUN curl -o /usr/local/bin/m2install.sh https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install.sh; \
    curl -o /etc/bash_completion.d/m2install-bash-completion https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install-bash-completion; \
    curl -o /usr/local/bin/n98-magerun2 https://files.magerun.net/n98-magerun2.phar; \
    curl -o /etc/bash_completion.d/n98-magerun2.phar.bash https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash; \
    curl -o /usr/local/bin/m2-convert-for-composer https://raw.githubusercontent.com/isitnikov/m2-convert-patch-for-composer-install/master/convert-for-composer.php; \
    curl -o /etc/bash_completion.d/magento2-bash-completion https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion-enterprise; \
    curl -L -o /tmp/teleport.tar.gz https://github.com/gravitational/teleport/releases/download/v1.3.2/teleport-v1.3.2-linux-amd64-bin.tar.gz \
    && tar -xf /tmp/teleport.tar.gz -C /tmp/ \
    && make -C /tmp/teleport/

# ADOBE TOOLS:
RUN git ls-remote git@github.com:magento-sparta/ee-support-tools.git 2>&1 | if grep -q HEAD; then git clone git@github.com:magento-sparta/ee-support-tools.git /usr/local/src/ee-support-tools; else echo; fi \
    && if [ -d /usr/local/src/ee-support-tools ]; then ln -s /usr/local/src/ee-support-tools/cloud-teleport/cloud-teleport /usr/local/bin/cloud-teleport; else echo; fi
RUN git ls-remote git@github.com:magento-sparta/m-it.git 2>&1 | if grep -q HEAD; then git clone git@github.com:magento-sparta/m-it.git /usr/local/src/m-it; else echo; fi \
    && if [ -d /usr/local/src/m-it ]; then /usr/local/src/m-it/mit-installer.sh; else echo; fi

# USER CONTEXT CONFIGURATION
USER magento

RUN mkdir -p ${_HOME_DIRECTORY}/.ssh \
    && touch ${_HOME_DIRECTORY}/.ssh/known_hosts \
    && ssh-keygen -F github.com || ssh-keyscan github.com >> ${_HOME_DIRECTORY}/.ssh/known_hosts

COPY ./services/web-servers/apache/etc/git/gitconfig ${_HOME_DIRECTORY}/.gitconfig
COPY ./services/web-servers/apache/etc/composer/auth.json* ${_HOME_DIRECTORY}/.composer/
COPY ./services/web-servers/apache/etc/m2install/.m2install.conf* ${_HOME_DIRECTORY}/

# BASH COMPLETION:
RUN echo "source /etc/bash_completion" >> ${_HOME_DIRECTORY}/.bashrc

# MAGENTO CLI:
RUN curl -sS https://accounts.magento.cloud/cli/installer | php

# ADOBE TOOLS:
RUN if [ -d /usr/local/src/m-it ]; then /usr/local/src/m-it/mit-installer.sh; else echo; fi
RUN sed -i.back '/^export BASH_IT_THEME=/ s/^/# /' ${_HOME_DIRECTORY}/.bashrc

USER root
RUN chown -R "${_USER}:${_USER}" ${_HOME_DIRECTORY}/.gitconfig ${_HOME_DIRECTORY}/.composer ${_HOME_DIRECTORY}/.m2install.conf*; \
    chmod +x /usr/local/bin/*
## END OF BASE IMAGE ##

## BASE IMAGE WITHOUT MAILCATCHER ##
FROM m2d_web_server_apache_php_base AS m2d_web_server_apache_php_base_mailcatcher_no

## BASE IMAGE WITH MAILCATCHER ##
FROM m2d_web_server_apache_php_base AS m2d_web_server_apache_php_base_mailcatcher_yes
RUN apt-get update && apt-get install -y msmtp
COPY ./services/web-servers/apache/etc/msmtprc /etc/msmtprc

## MAILCATCHER
FROM m2d_web_server_apache_php_base_mailcatcher_${M2D_ENABLE_MAILCATCHER} AS m2d_web_server_apache_php_base_mailcatcher


## BASE IMAGE WITHOUT BLACKFIRE ##
FROM m2d_web_server_apache_php_base_mailcatcher AS m2d_web_server_apache_php_base_blackfire_no

## BASE IMAGE WITH BLACKFIRE ##
FROM m2d_web_server_apache_php_base_mailcatcher AS m2d_web_server_apache_php_base_blackfire_yes

# BLACKFIRE:
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz \
    && mkdir -p /tmp/blackfire \
    && curl -A "Docker" -L https://blackfire.io/api/v1/releases/client/linux_static/amd64 | tar zxp -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire /usr/bin/blackfire \
    && rm -Rf /tmp/blackfire
## END OF BASE IMAGE WITH BLACKFIRE ##

FROM m2d_web_server_apache_php_base_blackfire_${M2D_ENABLE_BLACKFIRE} AS m2d_web_server_apache_blackfire

## IMAGE ADJUSTMENTS FOR PHP 7.x ##
FROM m2d_web_server_apache_blackfire AS m2d_web_server_apache_php7x

# COMPOSER 1 LINKED AS DEFAULT:
RUN ln -s /usr/local/bin/composer1 /usr/local/bin/composer

# XDEBUG:
ARG M2D_XDEBUG_IDE_KEY=PHPSTORM
ENV M2D_XDEBUG_IDE_KEY=${M2D_XDEBUG_IDE_KEY:-PHPSTORM}
RUN pecl install xdebug-2.9.0 \
    && echo ";zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=$M2D_XDEBUG_IDE_KEY" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level=10000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.remote_log = /var/www/html/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.remote_log_level = 10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.remote_port = 9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# ADDITIONAL EXTENSIONS
RUN pecl install libsodium-2.0.23
## END OF IMAGE ADJUSTMENTS FOR PHP 7.x ##


## IMAGE ADJUSTEMNTS FOR PHP 8.x
FROM m2d_web_server_apache_blackfire AS m2d_web_server_apache_php8x

# PHP EXTENSIONS GD:
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd

# COMPOSER 2 LINKED AS DEFAULT:
RUN ln -s /usr/local/bin/composer2 /usr/local/bin/composer

# XDEBUG:
ARG M2D_XDEBUG_IDE_KEY=PHPSTORM
ENV M2D_XDEBUG_IDE_KEY=${M2D_XDEBUG_IDE_KEY:-PHPSTORM}
RUN pecl install xdebug \
    && echo ";zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.idekey=$M2D_XDEBUG_IDE_KEY" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.max_nesting_level=10000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.log = /var/www/html/xdebug.log" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.log_level = 10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo ";xdebug.client_port = 9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
## END OF IMAGE ADJUSTMENTS FOR PHP 8.x ##


## IMAGE ADJUSTEMNTS FOR PHP 7.3 ##
FROM m2d_web_server_apache_php7x AS m2d_web_server_apache_php7.3
# PHP EXTENSIONS GD:
RUN docker-php-ext-configure gd --with-gd --with-webp-dir \
    --with-png-dir --with-zlib-dir --with-xpm-dir \
    --with-freetype-dir=/usr/include/freetype2/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
## END OF IMAGE ADJUSTMENTS FOR PHP 7.3 ##


## IMAGE ADJUSTEMNTS FOR PHP 7.4 ##
FROM m2d_web_server_apache_php7x AS m2d_web_server_apache_php7.4
# PHP EXTENSIONS GD:
RUN docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) gd
## END OF IMAGE ADJUSTMENTS FOR PHP 7.4 ##


## IMAGE ADJUSTEMNTS FOR PHP 8.0 ##
FROM m2d_web_server_apache_php8x AS m2d_web_server_apache_php8.0

# ADDITIONAL EXTENSIONS
RUN pecl install libsodium-2.0.23
## END OF IMAGE ADJUSTMENTS FOR PHP 8.0 ##


## IMAGE ADJUSTEMNTS FOR PHP 8.1 ##
FROM m2d_web_server_apache_php8x AS m2d_web_server_apache_php8.1
## END OF IMAGE ADJUSTMENTS FOR PHP 8.1 ##


## IMAGE ADJUSTEMNTS FOR PHP 8.2 ##
FROM m2d_web_server_apache_php8x AS m2d_web_server_apache_php8.2
## END OF IMAGE ADJUSTMENTS FOR PHP 8.2 ##


## TARGET IMAGE ADJUSTEMNTS ##
FROM m2d_web_server_apache_php${M2D_WEB_SERVER_PHP_VERSION} AS web_server
# CODESNIFFER:
RUN pear install PHP_CodeSniffer \
    && mkdir /usr/local/magento-ecg-code-sniffer \
    && cd /usr/local/magento-ecg-code-sniffer/ && composer require magento-ecg/coding-standard \
    && phpcs --config-set installed_paths /usr/local/magento-ecg-code-sniffer/vendor/magento-ecg/coding-standard
CMD service ssh start; apache2-foreground
