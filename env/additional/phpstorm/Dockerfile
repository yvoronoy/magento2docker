FROM ubuntu:16.04

RUN apt-get update && apt-get install -y curl \
	openjdk-8-jre \
	libxext-dev \
	libxrender-dev \
	libxtst-dev \
	git
RUN curl -O https://download-cf.jetbrains.com/webide/PhpStorm-2018.3.tar.gz
RUN mkdir -p /opt/phpstorm
RUN tar --strip-components=1 -xzf PhpStorm-2018.3.tar.gz -C /opt/phpstorm
RUN rm PhpStorm-2018.3.tar.gz
CMD /opt/phpstorm/bin/phpstorm.sh
