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
dev: up mount
dev-down: down umount

mount:
	sudo sshfs -o follow_symlinks -o allow_other -o IdentityFile=$(ROOT_DIR)/etc/ssh/magento2docker -o port=2222 root@127.0.0.1:/var/www/html $(SRC_DIR)
umount:
	sudo umount -f $(SRC_DIR)
clean:
	docker stop `docker ps -a -q`; docker rm `docker ps -a -q`

web:
	docker exec -it magento2web bash
db:
	docker exec -it magento2db bash
magento-console:
	docker exec -it magento2web n98-magerun2 dev:console
