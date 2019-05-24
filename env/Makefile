.PHONY: dev prod down stop build mount umount clean web db magento-console phpstorm
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR:=$(shell bash etc/host/config.sh SOURCE_DIRECTORY)

up:
	docker-compose up -d
down:
	docker-compose down
stop:
	docker-compose stop
build:
	docker-compose build --build-arg CACHEBUST=`date +%s`
logs:
	docker logs -f magento2web
logs-db:
	docker logs -f magento2db
logs-elastic:
	docker logs -f magento2elastic
logs-elastic5:
	docker logs -f magento2elastic5
add-host:
	echo "127.0.0.1 $(host)" | sudo tee -a /etc/hosts
	cp etc/apache/vhost.conf.example etc/apache/$(host).conf
	cat etc/apache/$(host).conf | sed "s/ServerName example.com/ServerName $(host)/" > etc/apache/$(host).conf.tmp
	mv etc/apache/$(host).conf.tmp etc/apache/$(host).conf
	cat etc/apache/$(host).conf | sed "s/\/var\/www\/html\/example/\/var\/www\/html\/$(host)/" > etc/apache/$(host).conf.tmp
	mv etc/apache/$(host).conf.tmp etc/apache/$(host).conf
	docker-compose build
	docker-compose up -d
	docker exec -it --user magento magento2web mkdir -p /var/www/html/$(host)
	docker exec -i --user magento magento2web sh -c "cat ~/.m2install.conf | sed 's/HTTP_HOST=.*/HTTP_HOST=http:\/\/$(host)\//g' | tee /var/www/html/$(host)/.m2install.conf 1>/dev/null"
	docker exec -i --user magento magento2web sh -c "sed -i 's/BASE_PATH=.*/BASE_PATH=/g' /var/www/html/$(host)/.m2install.conf"
remove-host:
	cat /etc/hosts | sed 's/.*$(host)//g' > /tmp/hosts.tmp
	sudo mv /tmp/hosts.tmp /etc/hosts
	rm etc/apache/$(host).conf
	docker-compose build
	docker-compose up -d
	docker exec -i --user magento magento2web sh -c "rm /var/www/html/$(host)/.m2install.conf"

dev: up mount
dev-stop: umount stop
all: up elastic mailcatcher solr

phpstorm:
	xhost + 127.0.0.1
	docker-compose -f docker-compose.phpstorm.yml build
	docker-compose -f docker-compose.yml -f docker-compose.phpstorm.yml up -d
mount:
	###############################################################################
	# DEPRECATED                                                                  #
	# Use PHPStorm IDE inside docker container  if you need work with source code #
	# Usage: make phpstorm                                                        #
	###############################################################################
	chmod 400 $(ROOT_DIR)/etc/ssh/magento2docker
	sshfs magento@127.0.0.1:/var/www/html $(SRC_DIR) -o reconnect -o StrictHostKeyChecking=no -o follow_symlinks -o IdentityFile=$(ROOT_DIR)/etc/ssh/magento2docker -o port=2222 -o compression=no
umount:
	umount -f $(SRC_DIR)
clean:
	docker stop `docker ps -a -q`; docker rm `docker ps -a -q`

web:
	docker exec -it --env COLUMNS=`tput cols` --env LINES=`tput lines` --user magento magento2web bash
db:
	docker exec -it magento2db bash
magento-console:
	docker exec -it magento2web n98-magerun2 dev:console

#Additional Containers
elastic:
	# Web interface:
	# http://127.0.0.1:9200
	cd additional/elasticsearch && docker-compose up -d && cd -
elastic-stop:
	cd additional/elasticsearch && docker-compose stop && cd -
elastic5:
	cd additional/elasticsearch5 && docker-compose up -d && cd -
	cd additional/elasticsearch5/kibana && docker-compose up -d && cd -
	# Web interface:
	# http://127.0.0.1:9205
	# Kibana Web Interface
	# http://127.0.0.1:5601
elastic5-stop:
	cd additional/elasticsearch5 && docker-compose stop && cd -
	cd additional/elasticsearch5/kibana && docker-compose stop && cd -
solr:
	cd additional/solr36 && docker-compose up -d && cd -
solr-stop:
	cd additional/solr36 && docker-compose stop && cd -
mailcatcher:
	cd additional/mailcatcher && docker-compose up -d && cd -
	# Management Console:
	# http://127.0.0.1:1080/
mailcatcher-stop:
	cd additional/mailcatcher && docker-compose stop && cd -
mysql55:
	# MySQL 5.5
	# Host: db55
	cd additional/mysql55 && docker-compose up -d && cd -
mysql55-stop:
	cd additional/mysql55 && docker-compose stop && cd -
rabbitmq:
	cd additional/rabbitmq && docker-compose up -d && cd -
	# Management Console:
	# http://localhost:15672
	# guest:guest
rabbitmq-stop:
	cd additional/rabbitmq && docker-compose stop && cd -
redis:
	cd additional/redis && docker-compose up -d && cd -
redis-cli:
	docker exec -it magento2redis redis-cli
redis-stop:
	cd additional/redis && docker-compose stop && cd -
varnish:
	cd additional/varnish && docker-compose up -d && cd -
	# Update port to 8080 for Magento Base URL configuration
varnish-cli:
	docker exec -it magento2varnish redis-cli
varnish-stop:
	cd additional/varnish && docker-compose stop && cd -
varnish-logs:
	docker logs -f magento2varnish

# vim: ts=4 sw=4 sts=4 sr noet
