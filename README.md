# Magento2 Docker Environment
A very simple Magento2 Docker Environment based on LAMP stack and Docker Sync by @EugenMayer.
Mac OSX ready environment with full speed syncing your code for development.

## Pre-requirements
 - [Install Docker](https://docs.docker.com/engine/installation/mac/)
 - [Install Docker Sync](https://github.com/EugenMayer/docker-sync/wiki/1.-Installation) (only for Mac OSX)
 - Copy `conf/auth.json.example` to `conf/auth.json` and add your [Access Keys](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/dev_install.html)

## Usage
### How to run containers
Run docker containers on Mac OSX by using next command:
```
docker-sync-stack start
```
OR
```
docker-sync start
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
```
If you are on Linux
just run `docker-compose up`


### How install a magento
 - When you run container your environment is ready on http://localhost:8000/
 - Login to container `docker exec -it magento2web bash` and run `m2install.sh -s composer`

### How deploy dumps
 - Put dumps to src folder on your host machine
 - Login to container `docker exec -it magento2web bash` and run `m2install.sh`


## TODO
 - Add xDebug and provide guide how to setup xDebug on your host machine.
 - Add useful tools like: n98-magerun2, m2install.sh, magento-bash-completion.
 - Setup Cron.

## Contributing
1. Fork this repository.
2. Create your feature branch: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin my-new-feature`.
5. Submit a pull request.

