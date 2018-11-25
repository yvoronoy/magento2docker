.PHONY: dev prod down stop build mount umount clean web db magento-console
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

dev: up mount
dev-stop: umount stop
all: up elastic mailcatcher solr

phpstorm:
	xhost + 10.254.254.254
	docker-compose -f docker-compose.yml -f docker-compose.phpstorm.yml up -d
mount:
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

# vim: ts=4 sw=4 sts=4 sr noet
