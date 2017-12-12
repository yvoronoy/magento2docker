.PHONY: dev prod down stop build mount umount clean web db magento-console
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR:=$(ROOT_DIR)/../src

up:
	docker-compose up -d
down:
	docker-compose down
stop:
	docker-compose stop
build:
	docker-compose build
logs:
	docker logs -f magento2web
dev: up mount
dev-stop: umount stop
all: up elastic mailcatcher solr

mount:
	chmod 400 $(ROOT_DIR)/etc/ssh/magento2docker
	sshfs -o reconnect -o StrictHostKeyChecking=no -o follow_symlinks -o IdentityFile=$(ROOT_DIR)/etc/ssh/magento2docker -o port=2222 root@127.0.0.1:/var/www/html $(SRC_DIR)
umount:
	umount -f $(SRC_DIR)
clean:
	docker stop `docker ps -a -q`; docker rm `docker ps -a -q`

web:
	docker exec -it magento2web bash
db:
	docker exec -it magento2db bash
magento-console:
	docker exec -it magento2web n98-magerun2 dev:console

#Additional Containers
elastic:
	cd additional/elasticsearch && docker-compose up -d && cd -
elastic-stop:
	cd additional/elasticsearch && docker-compose stop && cd -
solr:
	cd additional/solr36 && docker-compose up -d && cd -
solr-stop:
	cd additional/solr36 && docker-compose stop && cd -
mailcatcher:
	cd additional/mailcatcher && docker-compose up -d && cd -
mailcatcher-stop:
	cd additional/mailcatcher && docker-compose stop && cd -
redis:
	cd additional/redis && docker-compose up -d && cd -
redis-cli:
	docker exec -it magento2redis redis-cli
redis-stop:
	cd additional/redis && docker-compose stop && cd -

# vim: ts=4 sw=4 sts=4 sr noet
