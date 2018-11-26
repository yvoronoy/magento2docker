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
 - Install and setup XQuartz
   - Install `brew cask install xquartz`
   - Open `open -a XQuartz` and go to X11 Preferences
     - Goto Security tab and check Allow connections from network clients
     - Restart computer
   - Create ip 10.254.254.254 as an alias on your loopback device 127.0.0.1
     by using next command:
     ```
     sudo curl -o /Library/LaunchDaemons/osx.docker.loopback.plist
     https://raw.githubusercontent.com/yvoronoy/magento2docker/master/env/etc/osx.docker.loopback.plist \
     && sudo launchctl load /Library/LaunchDaemons/osx.docker.loopback.plist
     ```
     More details you can find here: https://gist.github.com/ralphschindler/535dc5916ccbd06f53c1b0ee5a868c93
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
make dev
```
That command will run docker-compose and mount sshfs into host src directory.

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

### Usage
 - Login to your container `make web`
 - Run command `xdebug-php.sh 1`
 - Run IDE (PHPStorm) and press button _Start Listening for PHPDebug Connection_

## Todo List
 - [x] Add xDebug and provide guide how to setup xDebug on your host machine.
 - [x] Add useful tools like: n98-magerun2, m2install.sh, magento-bash-completion.
 - [ ] Setup Cron.
 - [x] Add self-signed SSL certificate.
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

