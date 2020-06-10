#===================================================
# open vnc://:secret@127.0.0.1:5900
#===================================================
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# NOTE: DO *NOT* EDIT THIS FILE.  IT IS GENERATED.
# PLEASE UPDATE Dockerfile.txt INSTEAD OF THIS FILE
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
FROM selenium/node-chrome:3.141.59-zinc
LABEL authors=SeleniumHQ

USER root

#=====
# VNC
#=====
RUN apt-get update -qqy \
  && apt-get -qqy install \
  x11vnc \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN apt-get update && apt-get install -y curl \
	openjdk-8-jre \
	libxext-dev \
	libxrender-dev \
	libxtst-dev \
	git

#=========
# fluxbox
# A fast, lightweight and responsive window manager
#=========
RUN apt-get update -qqy \
  && apt-get -qqy install \
    fluxbox \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

###############################
# PHP STORM
###############################

RUN curl -O https://download-cf.jetbrains.com/webide/PhpStorm-2018.3.tar.gz
RUN mkdir -p /opt/phpstorm
RUN tar --strip-components=1 -xzf PhpStorm-2018.3.tar.gz -C /opt/phpstorm
RUN rm PhpStorm-2018.3.tar.gz

RUN mkdir ${_HOME_DIRECTORY}/.PhpStorm2018.3
RUN mkdir ${_HOME_DIRECTORY}/.java

USER seluser

#==============================
# Generating the VNC password as seluser
# So the service can be started with seluser
#==============================

RUN mkdir -p ${HOME}/.vnc \
  && x11vnc -storepasswd secret ${HOME}/.vnc/passwd

#==========
# Relaxing permissions for OpenShift and other non-sudo environments
#==========
RUN sudo chmod -R 777 ${HOME} \
  && sudo chgrp -R 0 ${HOME} \
  && sudo chmod -R g=u ${HOME}

#==============================
# Scripts to run fluxbox and x11vnc
#==============================
COPY start-fluxbox.sh \
      start-vnc.sh \
      /opt/bin/

#==============================
# Supervisor configuration file
#==============================
COPY selenium-debug.conf /etc/supervisor/conf.d/


EXPOSE 5900

