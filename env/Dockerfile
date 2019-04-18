FROM php:7.1-apache
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng-dev \
        libxslt-dev \
        libicu-dev \
        mysql-client \
        pv \
        vim \
        bash-completion \
        openssh-server \
        ssl-cert \
        msmtp \
        sudo \
        dnsutils \
        iputils-ping \
        iputils-tracepath \
        host \
        telnet \
        unzip \
        gnupg \
    && docker-php-ext-install -j$(nproc) iconv mcrypt soap sockets \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd bcmath pdo_mysql xsl intl zip
RUN apt-get update              \
         &&      apt-get install -y git      \
         &&      apt-get clean all
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -y nodejs
#Blackfire
RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz
RUN mkdir -p /tmp/blackfire \
    && curl -A "Docker" -L https://blackfire.io/api/v1/releases/client/linux_static/amd64 | tar zxp -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire /usr/bin/blackfire \
    && rm -Rf /tmp/blackfire
#End blackfire

ENV _USER=magento
ENV _HOME_DIRECTORY=/home/${_USER}
RUN useradd -m ${_USER} && echo "${_USER}:${_USER}" | chpasswd && chsh ${_USER} -s /bin/bash && adduser ${_USER} sudo

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN pecl install xdebug-2.5.5
RUN echo ";zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_host=10.254.254.254" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.max_nesting_level=10000" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
RUN echo "xdebug.idekey=PHPSTORM" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

#RUN cd /tmp/ && curl -OL https://downloads.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && cd -
#RUN cd /tmp/ && tar xf ioncube_loaders_lin_x86-64.tar.gz && cd -
#RUN cp /tmp/ioncube/ioncube_loader_lin_7.0.so /usr/local/lib/php/extensions/no-debug-non-zts-20151012/ioncube_loader_lin_7.0.so
#RUN echo "zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20151012/ioncube_loader_lin_7.0.so" >> /usr/local/etc/php/conf.d/docker-php-ext-ioncube.ini

RUN pear install PHP_CodeSniffer
RUN mkdir /usr/local/magento-ecg-code-sniffer
RUN cd /usr/local/magento-ecg-code-sniffer/ && composer require magento-ecg/coding-standard
RUN phpcs --config-set installed_paths /usr/local/magento-ecg-code-sniffer/vendor/magento-ecg/coding-standard

RUN echo "sendmail_path=/usr/bin/msmtp -t" >> /usr/local/etc/php/conf.d/mailcatcher.ini
RUN echo "memory_limit=2G" >> /usr/local/etc/php/conf.d/custom.ini
RUN echo "max_input_vars=10000" >> /usr/local/etc/php/conf.d/custom.ini
RUN echo "account default" >> /etc/msmtprc
RUN echo "host mailcatcher" >> /etc/msmtprc
RUN echo "port 1025" >> /etc/msmtprc
RUN echo "auto_from on" >> /etc/msmtprc

#GIT
COPY ./etc/git/gitconfig ${_HOME_DIRECTORY}/.gitconfig

COPY ./etc/composer/auth.json /${_HOME_DIRECTORY}/.composer/auth.json

#SSH
COPY ./etc/ssh ${_HOME_DIRECTORY}/.ssh
ADD ./etc/ssh/magento2docker.pub ${_HOME_DIRECTORY}/.ssh/authorized_keys
RUN chmod -R 700 ${_HOME_DIRECTORY}/.ssh
RUN echo "    ServerAliveInterval 30" >> /etc/ssh/ssh_config
RUN echo "    TCPKeepAlive yes" >> /etc/ssh/ssh_config

COPY ./etc/ssh /root/.ssh
ADD ./etc/ssh/magento2docker.pub /root/.ssh/authorized_keys
RUN chmod -R 700 /root/.ssh
#END

RUN echo "Ciphers aes128-ctr,aes192-ctr,aes256-ctr,aes128-gcm@openssh.com,aes256-gcm@openssh.com,chacha20-poly1305@openssh.com,blowfish-cbc,aes128-cbc,3des-cbc,cast128-cbc,arcfour,aes192-cbc,aes256-cbc" >> /etc/ssh/sshd_config
COPY ./misc/xdebug-php.sh /usr/local/bin/xdebug-php.sh

#APACHE
RUN a2enmod ssl
RUN a2ensite default-ssl.conf
RUN a2enmod vhost_alias
RUN a2enmod proxy

RUN a2enmod rewrite
RUN chown -R ${_USER}:${_USER} /var/www/html
COPY ./etc/apache/envvars /etc/apache2/envvars
#APACHE END

RUN chown -R ${_USER}:${_USER} ${_HOME_DIRECTORY}

#USER SPECIFYC
USER magento
RUN echo "source /etc/bash_completion" >> ${_HOME_DIRECTORY}/.bashrc
RUN curl -sS https://accounts.magento.cloud/cli/installer | php
USER root

# Tune environment
RUN echo "Defaults    timestamp_timeout=-1" >> /etc/sudoers

# Hack to not cache https://github.com/docker/docker/issues/1996#issuecomment-185872769
ARG CACHEBUST=1
COPY ./misc/* /usr/local/bin/
COPY ./etc/apache /etc/apache2/sites-enabled/
COPY ./etc/fixtures /etc/fixtures
COPY ./etc/m2install/.m2install.conf* ${_HOME_DIRECTORY}/

RUN curl -o /usr/local/bin/m2install.sh https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install.sh
RUN curl -o /etc/bash_completion.d/m2install-bash-completion https://raw.githubusercontent.com/yvoronoy/m2install/master/m2install-bash-completion
RUN curl -o /usr/local/bin/n98-magerun2 https://files.magerun.net/n98-magerun2.phar
RUN curl -o /etc/bash_completion.d/n98-magerun2.phar.bash https://raw.githubusercontent.com/netz98/n98-magerun2/master/res/autocompletion/bash/n98-magerun2.phar.bash
RUN curl -o /usr/local/bin/m2-convert-for-composer https://raw.githubusercontent.com/isitnikov/m2-convert-patch-for-composer-install/master/convert-for-composer.php
RUN curl -o /etc/bash_completion.d/magento2-bash-completion https://raw.githubusercontent.com/yvoronoy/magento2-bash-completion/master/magento2-bash-completion-enterprise
RUN curl -L -o /tmp/teleport.tar.gz https://github.com/gravitational/teleport/releases/download/v1.3.2/teleport-v1.3.2-linux-amd64-bin.tar.gz
RUN tar -xf /tmp/teleport.tar.gz -C /tmp/
RUN make -C /tmp/teleport/

RUN touch /root/.ssh/known_hosts
RUN ssh-keygen -F github.com || ssh-keyscan github.com >> /root/.ssh/known_hosts
RUN git ls-remote git@github.com:magento-sparta/ee-support-tools.git 2>&1 | if grep -q HEAD; then git clone git@github.com:magento-sparta/ee-support-tools.git /usr/local/src/ee-support-tools; else echo; fi
RUN if [ -d /usr/local/src/ee-support-tools ]; then ln -s /usr/local/src/ee-support-tools/cloud-teleport/cloud-teleport /usr/local/bin/cloud-teleport; else echo; fi

RUN chmod +x /usr/local/bin/*

CMD service ssh start; apache2-foreground
