# Magento2 Docker Environment
Magento2 Docker Environment based on LAMP stack. Tested on docker for mac.
This project uses SSHFS to mount container directory on a host machine. Due to docker issue [File access in mounted volumes extremely slow](https://github.com/docker/for-mac/issues/77).

I used to Docker Sync project before to synchronize files by UNISON. But it brokes very often,because Magento2 has huge amount of files. So I decided to move on SSHFS. It works pretty well and performance is enough on a host machine. Container works without any performance issue since it does not share volumes.

## Contents

- [Pre-requirements](#pre-requirements)
- [Installation](#installation)
- [Usage](#usage)
 - [Quick Start](#quick-start)
 - [How install a magento](#how-install-magento)
 - [How deploy magento dumps](#how-deploy-dumps)
- [How to Enable xDebug](#how-to-enable-xdebug)
 - [Pre-requirements](#pre-requirements-1)
 - [Usage](#usage-1)
- [Todo List](#todo-list)
- [Contributing](#contributing)

## Pre-requirements
 - [Install Docker](https://docs.docker.com/engine/installation/mac/)
 - Install SSHFS on Mac OSX.
   - `brew install Caskroom/cask/osxfuse`
   - `brew install sshfs`
 - Copy `etc/composer/auth.json.example` to `etc/composer/auth.json` and add your [Access Keys](http://devdocs.magento.com/guides/v2.0/install-gde/prereq/dev_install.html)
 
## Installation
You can download archive of this project on [Release Page](https://github.com/yvoronoy/magento2docker/releases). 

Or just clone this repository ```git clone git@github.com:yvoronoy/magento2docker.git```

## Usage
### Quick Start
Commands should be executed from _env_ directory.
Run make command to run developer environment.

```
make dev
```
That command will run docker-compose and mount sshfs into host src directory.

Your Magento2 Environment is ready and available here: [http://127.0.0.1:8000/](http://127.0.0.1/).
The next step you can open container and install Magento2.

### How to install a magento inside container
 - When you run container your environment is ready on http://127.0.0.1:8000/
   - Login to container `make web`
   - Run `m2install.sh -s composer`

### How to deploy dumps (backups) inside container
 - Put dumps to src folder on your host machine
   - Login to container `make web` 
   - Run `m2install.sh`

## How to Enable xDebug

The container already includes PHP xDebug extension. The xDebug extension is disabled by default because
it is dramatically decrease performance.

### Pre-requirements
xDebug configuration is using remote host ip = 10.254.254.254.

if you are using Mac OSX you have to create ip 10.254.254.254 as an alias on your loopback device 127.0.0.1
by using next command:
```
sudo curl -o /Library/LaunchDaemons/osx.docker.loopback.plist \
https://raw.githubusercontent.com/yvoronoy/magento2docker/master/env/etc/osx.docker.loopback.plist \
&& sudo launchctl load /Library/LaunchDaemons/osx.docker.loopback.plist
```
More details you can find here: https://gist.github.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93

Also you can create loop back alias by using next command: `ifconfig lo0 alias 10.254.254.254` 

### Usage
 - Login to your container `docker exec -it magento2web bash`
 - Run command `xdebug-php.sh 1`
 - Run IDE (PHPStorm) and press button _Start Listening for PHPDebug Connection_

## Todo List
 - [x] Add xDebug and provide guide how to setup xDebug on your host machine.
 - [x] Add useful tools like: n98-magerun2, m2install.sh, magento-bash-completion.
 - [ ] Setup Cron.
 - [ ] Add self-signed SSL certificate.
 - [ ] Add Magento Testing Framework for functional tests.
 - [ ] Add Solr Search Engine.
 - [ ] Add Blackfire tool.

## Contributing
1. Fork this repository.
2. Create your feature branch: `git checkout -b my-new-feature`.
3. Commit your changes: `git commit -am 'Add some feature'`.
4. Push to the branch: `git push origin my-new-feature`.
5. Submit a pull request.

## Credits
Special thanks to @snosov and @tshabatyn who share their ideas and inspired to build this project.

