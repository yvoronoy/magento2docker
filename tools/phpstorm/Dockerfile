FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl \
	openjdk-8-jre \
	libxext-dev \
	libxrender-dev \
	libxtst-dev \
	git

ENV _USER=magento
ENV _HOME_DIRECTORY=/home/${_USER}
RUN useradd -m ${_USER} && echo "${_USER}:${_USER}" | chpasswd && chsh ${_USER} -s /bin/bash && adduser ${_USER} sudo

#SSH
COPY ./services/web-servers/apache/etc/ssh ${_HOME_DIRECTORY}/.ssh
RUN chmod -R 700 ${_HOME_DIRECTORY}/.ssh

#GIT
COPY ./services/web-servers/apache/etc/git/gitconfig ${_HOME_DIRECTORY}/.gitconfig
COPY ./services/web-servers/apache/etc/composer/auth.json ${_HOME_DIRECTORY}/.composer/auth.json

RUN chown -R ${_USER}:${_USER} ${_HOME_DIRECTORY}

RUN curl -O https://download-cf.jetbrains.com/webide/PhpStorm-2020.1.tar.gz
RUN mkdir -p /opt/phpstorm
RUN tar --strip-components=1 -xzf PhpStorm-2020.1.tar.gz -C /opt/phpstorm
RUN rm PhpStorm-2020.1.tar.gz

USER magento
RUN mkdir ${_HOME_DIRECTORY}/.PhpStorm2020.1
RUN mkdir ${_HOME_DIRECTORY}/.java
CMD /opt/phpstorm/bin/phpstorm.sh
