.PHONY: dev prod down stop bash magento magento-console install deploy-dumps build umount mount
ARG=
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
SRC_DIR:=$(ROOT_DIR)/../src

dev:
	docker-compose up -d;
	sudo sshfs -o follow_symlinks -o allow_other -o IdentityFile=$(ROOT_DIR)/etc/ssh/magento2docker -o port=2222 root@127.0.0.1:/var/www/html $(SRC_DIR)
prod:
	docker-compose up -d
down:
	docker-compose down
stop:
	docker-compose stop
build:
	docker-compose build
mount:
	sudo sshfs -o follow_symlinks -o allow_other -o IdentityFile=$(ROOT_DIR)/etc/ssh/magento2docker -o port=2222 root@127.0.0.1:/var/www/html $(SRC_DIR)
umount:
	sudo umount -f $(SRC_DIR)


bash:
	docker exec -it magento2web bash
magento:
	docker exec -it magento2web bin/magento $(ARG)
install:
	docker exec -it magento2web m2install.sh -f -s composer -v $(ARG)
deploy-dumps:
	docker exec -it magento2web m2install.sh -f
magento-console:
	docker exec -it magento2web n98-magerun2 dev:console
clean:
	docker stop `docker ps -a -q`; docker rm `docker ps -a -q`
	umount -f $(ROOT_DIR)/../src/
