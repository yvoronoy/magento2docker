# Magento2Docker Environment
A near to perfect Magento2 Development Environment OS agnostic, OSX focused.
Key features of the project:
 - Simple Apache PHP container based on original images.
 - Ideal to work with multiple projects same time.
 - Multi-project setup with clean host names. Based on external nip.io wildcard DNS server.
 - Provides real-time file synchronization by Mutagen.
 - Includes PHPStorm container which can be rendered by X.ORG port for OSX.
 - Includes great set of tools with zero configuration like Blackfire, XDebug.
 - Includes all external services needed by Magento: ElasticSearch, Opensearch, Redis, Varnish, MySQL, MariaDB, MailCatcher, RabbitMQ, other.
 - Provides bash CLI tool a wrapper. Simplify managing containers.
 - Fully compatible with standard docker-compose commands.
 - Intel and Apple M1 CPU support.
 - Easily extensible.
 - Single docker-compose.yaml file approach with .env file to configure everything.
## Contents
- [Pre-requirements](#pre-requirements)
 - [How to install it on Mac](#how-to-install-it-on-mac)
 - [Directory requirements](#directory-requirements)
- [Installation](#installation)
- [Supported services and tools](#supported-services-and-tools)
- [Usage](#usage)
 - [Quick Start](#quick-start)
 - [How to install a magento](#how-install-magento)
 - [How to deploy magento dumps/backups](#how-deploy-dumps)
- [How to use xDebug](#how-to-enable-xdebug)
- [How to use Blackfire](#how-to-start-using-blackfire)
 - [Pre-requirements](#pre-requirements-1)
 - [Usage](#usage-1)
- [How to run PHPStorm inside container](#how-to-run-phpstorm-inside-container)
- [Todo List](#todo-list)
- [Contributing](#contributing)

## Pre-requirements
 - [Install Docker](https://docs.docker.com/engine/installation/mac/)
 - [Install Mutagen](https://mutagen.io/documentation/introduction/installation/)
 - Bash > 4.0
 - Realpath

 ### How to install it on Mac
```bash
# Mutagen:
brew install mutagen-io/mutagen/mutagen
# Bash:
brew install bash
# Realpath:
brew install coreutils
```

### Directory requirements
1. Magento2Docker as a tool can be located in any directory, e.g. ~/tools/m2d
2. Web container will use /var/www/html as its root folder for web content.
3. The M2D_SOURCE_DIRECTORY must point to a local path where you want to sync /var/www/html from the web container.
4. The M2D_SOURCE_DIRECTORY must not point to symlink or it will trigger errors when Mutagen is responsible for sync process.

## Installation
You can download archive of this project on [Release Page](https://github.com/yvoronoy/magento2docker/releases).

 - Clone or Download the repository ```git clone git@github.com:yvoronoy/magento2docker.git```
 - Go to project folder
 - Execute setup creator `./bin/m2d setup init`
 - Optional: fine tune all setings by editing `.env` file

## Supported services and tools
### Web Servers
- Apache with PHP: 7.3, 7.4, 8.0, 8.1, 8.2

### DB Engines
- MySQL: 5.7, 8.0, 8.0-oracle, and 5.7 as 5, 8.0.28 as 8
- MariaDB: 10.2, 10.3, 10.4, 10.6, and 10.4 as 10

### Search Engines
- Opensearch: 1.2.4 as 1.2, 1.2.4 as 1, 2.5.0 as 2.5, 2.5.0 as 2
- Elasticsearch: 6.8.23 as 6, 7.16.3 as 7, 7.6.2 as 7.6, 7.7.1 as 7.7, 7.9.3 as 7.9, 7.10.1 as 7.10, 7.16.3 as 7.16, 7.17.9 as 7.17, 8.4.3 as 8, 8.4.3 as 8.4

### DB Cache Engines
- Redis: 6.2, 5.0 as 5, 6.0 as 6, 7.0 as 7

### Web Cache Engines
- Varnish: 6.0, 6.2, 6.4, 6.5, 7.0, 7.1, and 7.0 as 7, 6.5 as 6

### Tools
- Blackfire: latest
- Mailcatcher: latest
- Selenium: 3.14.0

### Domains
With the default setup, Magento2Docker will use nip.io in this way:
`http://{LEVEL_2}.{LEVEL_1}.127.0.0.1.nip.io`
where:
- LEVEL_1 is a name of a folder inside /var/www/html
- LEVEL_2 is a subdomain that can be used to simulate multi-website Magento setup

Assume you have a multi-website Magento setup in the m246 folder; your domains can look like this:
- http://m246.127.0.0.1.nip.io
- http://website1.m246.127.0.0.1.nip.io
- http://website2.m246.127.0.0.1.nip.io
All the above will point to /var/www/html/m246 in your container.


## Usage
To work with Magento2Docker you can use `m2d` CLI command located in `bin` of Magento2Docker project.
### Quick Start
With Magento2Docker v3 it is super easy to start or stop containers:
```bash
# Display help
./bin/m2d --help

# To start containers:
./bin/m2d up

# To stop containers:
./bin/m2d stop

# To stop and remove containers and networks:
./bin/m2d down

# To enable service e.g. mailcatcher
./bin/m2d enable mailcatcher

# To disable service e.g. elasticsearch:
./bin/m2d disable search-engine

# To edit any .env parameter (e.g. PHP version):
./bin/m2d set M2D_WEB_SERVER_PHP_VERSION 8.1

# To display any .env parameter (e.g. search engine type):
./bin/m2d show M2D_SEARCH_ENGINE_VENDOR

# To start containers after enabling or disabling services or editing parameters:
./bin/m2d up --build
```


### How to install a magento inside container
   - Login to container `./bin/m2d go web`
   - Create a directory e.g: magento2
   - Inside the magento2 directory run `m2install.sh -s composer -v 2.4.6`
   - Open browser and go to http://magento2.127.0.0.1.nip.io/

### How to deploy dumps (backups) inside container
 - Put dumps to src folder on your host machine
   - Login to container `./bin/m2d go web`
   - Run `m2install.sh`

## How to link Composer versions

Containers with PHP 7.x have Composer 1 set as default, containers with PHP 8.x have Composer 2 set as default version.

### Usage:
- Login to container `./bin/m2d go web`
- To use composer as default you have two commands:
  - Run command `sudo composer-link.sh 1` to use Composer 1
  - Run command `sudo composer-link.sh 2` to use Composer 2

## How to Enable xDebug

The container already includes PHP xDebug extension. The xDebug extension is disabled by default because
it is dramatically decrease performance.

### Usage
 - Login to your container `./bin/m2d go web`
 - Run command `sudo xdebug-php.sh 1`
 - Run IDE (PHPStorm) and press button _Start Listening for PHPDebug Connection_


## Persistent folders
### Any file saved out of these folders will be lost when the container is terminated
  - /var/www/html
  - /home
  - /root
  - /root/.composer/cache

## How to start using Blackfire
[Blackfire Profiler](https://blackfire.io/docs/introduction) is a PHP profiler and automated performance testing tool. It enables you to investigate performance issues in very simple way, just install a browser extension and press the button. You will get granular performance report to measure CPU, IO, Memory, Network, etc.
Profiling with Blackfire is on-demand. This means that Blackfire adds no overhead for your end users, which makes it safe to use in production.

### Get your Blackfire credentials
Blackfire provides you a free account "Hack" which allows you to run profiles on your development environment.
 - Create account and login here: https://blackfire.io/login
 - Install Browser Extension https://blackfire.io/docs/integrations/chrome
 - Go to the page https://blackfire.io/docs/integrations/docker
   - Define these environment variables from this page on the host system (OSX)
   - You can save them permanently by putting them into ~/.bash_profile file
 - Enable blackfire container `./bin/m2d enable blackfire`
 - Recreate containers by using command `./bin/m2d up --build`

## How to run PHPStorm inside container

### Pre-requirements
 - Install and setup XQuartz
   - Install `brew cask install xquartz`
   - Open `open -a XQuartz` and go to X11 Preferences
     - Goto Security tab and check Allow connections from network clients
     - Restart computer
### Usage
Run the following command inside env directory

```
docker-compose -f docker-compose.phpstorm.yml up -d --build
```

## Todo List

## Contributing
1. Fork this repository.
2. Create your feature branch: `git checkout -b feature/my-cool-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin feature/my-cool-feature`.
5. Submit a pull request.

## Credits
Special thanks to @snosov and @tshabatyn who share their ideas and inspired to build this project.
