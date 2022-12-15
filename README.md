# Magento2 Docker Environment
An Ideal Magento2 Development Environment OSX Centric.
Key features of the project:
 - Simple Apache PHP container based on original images.
 - Ideal to work with multiple projects same time
 - Multi-project setup with clean host names. Based on external nip.io wildcard DNS server.
 - Provides real-time file synchronization by Mutagen
 - Includes PHPStorm container which can be rendered by X.ORG port for OSX
 - Includes great set of tools with zero configuration like Blackfire, XDebug.
 - Includes external services: ElasticSearch 2.x - 6.x, Redis, MailCatcher, RabbitMQ.
 - Provides Make tool as a wrapper. Simplify managing containers and support bash completion to hightlight commands.

## Contents

- [Pre-requirements](#pre-requirements)
- [Installation](#installation)
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
 - [Install bash completion (optional)](https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion)
 
## Installation
You can download archive of this project on [Release Page](https://github.com/yvoronoy/magento2docker/releases).

 - Clone or Download the repository ```git clone git@github.com:yvoronoy/magento2docker.git```
 - Copy or create `env/etc/composer/auth.json` and put your [Access Keys](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/dev_install.html)
   - `cp env/etc/composer/auth.json.example env/etc/composer/auth.json`
   - Edit env/etc/composer/auth.json and put your credentials [Access Keys](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/dev_install.html)
 - Update your gitconfig if needed
   - `cp env/etc/git/gitconfig.example env/etc/git/gitconfig`
 - Update and edit Commerce Cloud CLI Token
   - `cp env/.env.example env/.env`
 - (Optional) Copy your private ssh keys, configs to have access to resources from inside container
    - `cp ~/.ssh/id_rsa env/etc/ssh/`
    - `cp ~/.ssh/config env/etc/ssh/`

## Usage
### Quick Start
Commands should be executed from _env_ directory.
Run make command to run environment.

```
# Build and mount containers (default: php-7.4)
bin/up

# Login on web server container
bin/shell

# Change php version
  - For php-7.3: make up73
  - For php-7.4: make up74
  - For php-8.0: make up80
  - For php-8.1: make up81
```

### How to install a magento inside container
   - Login to container `make web`
   - Create a directory e.g: magento2
   - Inside the magento2 directory run `m2install.sh -s composer -v 2.3.3`
   - Open browser and go to http://magento2.127.0.0.1.nip.io/

### How to deploy dumps (backups) inside container
 - Put dumps to src folder on your host machine
   - Login to container `make web` 
   - Run `m2install.sh`

## How to link Composer versions

Containers for PHP 7.4, PHP 8.0, and PHP 8.1 has Composer 2 because of Magento supports Composer 2 since 2.4.2
version.

### Usage:
- Login to your container `bin/shell-root`
- To use composer as default you have two commands:
  - Run command `composer-link.sh 1` to use Composer 1 
  - Run command `composer-link.sh 2` to use Composer 2 

## How to Enable xDebug

The container already includes PHP xDebug extension. The xDebug extension is disabled by default because
it is dramatically decrease performance.

### Usage
 - Login to your container `make web`
 - Run command `xdebug-php.sh 1`
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
 - Recreate containers by using command `make up`

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
make phpstorm
```

## Todo List

## Contributing
1. Fork this repository.
2. Create your feature branch: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin my-new-feature`.
5. Submit a pull request.

## Credits
Special thanks to @snosov and @tshabatyn who share their ideas and inspired to build this project.

