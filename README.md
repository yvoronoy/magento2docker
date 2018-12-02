# Magento2 Docker Environment
The Perfect Magento2 Development Environment Mac OSX Centric.
Key features of the project:
 - Simple Apache PHP container based on original images.
 - Multi-project setup with clean host names. Based on external xip.io wildcard DNS server.
 - Do not share source with host and runs PHPStorm IDE inside container instead.
 - Includes great set of tools with zero configuration like Blackfire, XDebug.
 - Includes external services: ElasticSearch 2.X & 5.X, Redis, MailCatcher, RabbitMQ.
 - Use Make tool as a wrapper. Simplify managing containers and support bash completion to hightlight commands.

## Contents

- [Pre-requirements](#pre-requirements)
- [Installation](#installation)
- [Usage](#usage)
 - [Quick Start](#quick-start)
 - [How install a magento](#how-install-magento)
 - [How deploy magento dumps](#how-deploy-dumps)
- [How to Enable xDebug](#how-to-enable-xdebug)
- [How to start using Blackfire](#how-to-start-using-blackfire)
 - [Pre-requirements](#pre-requirements-1)
 - [Usage](#usage-1)
- [Todo List](#todo-list)
- [Contributing](#contributing)

## Pre-requirements
 - [Install Docker](https://docs.docker.com/engine/installation/mac/)
 - Install and setup XQuartz
   - Install `brew cask install xquartz`
   - Open `open -a XQuartz` and go to X11 Preferences
     - Goto Security tab and check Allow connections from network clients
     - Restart computer
 - Copy or create `env/etc/composer/auth.json` and put your [Access Keys](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/dev_install.html)
   - `cp env/etc/composer/auth.json.example env/etc/composer/auth.json`
   - Edit env/etc/composer/auth.json and put your credentials [Access Keys](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/dev_install.html)
  - Copy your private ssh keys, configs to have access to resources from inside container
    - `cp ~/.ssh/id_rsa env/etc/ssh/`
    - `cp ~/.ssh/config env/etc/ssh/`
  - Update your gitconfig if needed
    - `cp env/etc/git/gitconfig.example env/etc/git/gitconfig`
  - [Install bash completion (optional)](https://github.com/bobthecow/git-flow-completion/wiki/Install-Bash-git-completion)
 
## Installation
You can download archive of this project on [Release Page](https://github.com/yvoronoy/magento2docker/releases). 

Or just clone this repository ```git clone git@github.com:yvoronoy/magento2docker.git```

## Usage
### Quick Start
Commands should be executed from _env_ directory.
Run make command to run developer environment.

```
make phpstorm
```
That command will run docker-compose and phpstorm from container.

If you need just web server + db container use:
```
make up
```

### How to install a magento inside container
   - Login to container `make web`
   - Create a directory e.g: magento2
   - Inside the magento2 directory run `m2install.sh -s composer -v 2.2.6`
   - Open browser and go to http://magento2.127.0.0.1.xip.io/

### How to deploy dumps (backups) inside container
 - Put dumps to src folder on your host machine
   - Login to container `make web` 
   - Run `m2install.sh`

## How to Enable xDebug

The container already includes PHP xDebug extension. The xDebug extension is disabled by default because
it is dramatically decrease performance.

### Pre-requirements
xDebug configuration is using remote host ip = 10.254.254.254.
You need to have the IP 10.254.254.254 as an alias on your loopback device 127.0.0.1.
You can use the following command to create a permanent loopback:

sudo curl -o /Library/LaunchDaemons/osx.docker.loopback.plist \
https://raw.githubusercontent.com/yvoronoy/magento2docker/master/env/etc/osx.docker.loopback.plist \
&& sudo launchctl load /Library/LaunchDaemons/osx.docker.loopback.plist
More details you can find here: https://gist.github.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93

Also you can create loop back alias by using next command: ifconfig lo0 alias 10.254.254.254

### Usage
 - Login to your container `make web`
 - Run command `xdebug-php.sh 1`
 - Run IDE (PHPStorm) and press button _Start Listening for PHPDebug Connection_


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

## Todo List
 - [ ] JMeter tool to perform stress testing
 - [ ] Add Selenium to run tests

## Contributing
1. Fork this repository.
2. Create your feature branch: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin my-new-feature`.
5. Submit a pull request.

## Credits
Special thanks to @snosov and @tshabatyn who share their ideas and inspired to build this project.

