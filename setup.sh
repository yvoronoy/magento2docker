#!/bin/bash

#bootstrap
# verify if it is root
if [[ $EUID -eq 0 ]]; then
  echo "This script must NOT be run with sudo/root. Please re-run without sudo." 1>&2
  exit 1
fi

echo "This script is meant to run only once."

HOST_OS=`uname -s`
HOST_PATH=$(pwd)
HOST_USER_NAME=$(id -un) 
U=`id -u`
G=`id -g`

#menu
while (true)
do
    clear
    echo "If you want to run all the volumes natively from docker, you don't need to run this script"
    echo " "
    echo " "
    echo "Select the method to map your docker volume"
    echo " "
    echo " "
    echo " 1 - Map your local 'src' directory as shared volume: Recomended only for linux users"
    echo " "
    echo " 2 - Create and map your local 'nfs' directory through nfs: Exclusive for MAC users"
    read n
    case $n in
        1) selected=1; break;;
        2) selected=2; break;;
        *) selected=na; break;;
    esac
done

if [ "$selected" == "na" ]; then
    echo no changes made
fi

#Linux------->
if [ "$selected" == "1" ]; then
    echo linux
    if [ $HOST_OS == "Darwin" ]; then
        echo "This options is not suposed to use on MAC due several performance degradation"
        echo ""
        echo -n "Do you wish to proceed? [y]: "
        read decision

        if [ "$decision" != "y" ]; then
        echo "Exiting. No changes made."
        exit 1
        fi
    fi
 
    sed -i '' 's|- src-volume:/var/www/html|./src:/var/www/html|g' env/docker-compose.yml
    sed -i '' 's|src-volume:||g' env/docker-compose.yml
fi

#MAC------->
if [ "$selected" == "2" ]; then
    echo 2 - setup for MAC selected
    if [ $HOST_OS != "Darwin" ]; then
        echo "This script is OSX-only. Please do not run it on any other Unix."
        exit 1
    fi

    echo ""
    echo " +-----------------------------+"
    echo " | Setup native NFS for Docker |"
    echo " +-----------------------------+"
    echo ""

    echo "WARNING: This script will shut down running containers."
    echo ""
    echo -n "Do you wish to proceed? [y]: "
    read decision

    if [ "$decision" != "y" ]; then
    echo "Exiting. No changes made."
    exit 1
    fi

    echo ""

    if ! docker ps > /dev/null 2>&1 ; then
    echo "== Waiting for docker to start..."
    fi

    open -a Docker

    while ! docker ps > /dev/null 2>&1 ; do sleep 2; done

    echo "== Stopping running docker containers..."
    docker-compose down > /dev/null 2>&1
    docker volume prune -f > /dev/null

    osascript -e 'quit app "Docker"'

    echo "== Resetting folder permissions..."

    sudo chown -R "$U":"$G" .

    echo "== Setting up nfs..."
    LINE="/Users -alldirs -mapall=$U:$G localhost"
    FILE=/etc/exports
    sudo cp /dev/null $FILE
    grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE > /dev/null

    LINE="nfs.server.mount.require_resv_port = 0"
    FILE=/etc/nfs.conf
    grep -qF -- "$LINE" "$FILE" || sudo echo "$LINE" | sudo tee -a $FILE > /dev/null

    echo "== Restarting nfsd..."
    sudo nfsd restart

    echo "== Restarting docker..."
    open -a Docker

    while ! docker ps > /dev/null 2>&1 ; do sleep 2; done

    echo "== Preparing files..."
    sed -i '' 's|_USER=magento|_USER='$HOST_USER_NAME'|g' env/dockerfile
    sed -i '' 's|USER magento|USER '$HOST_USER_NAME'|g' env/dockerfile
    sed -i '' 's|_USER=magento|_USER='$HOST_USER_NAME'|g' env/additional/phpstorm/Dockerfile
    sed -i '' 's|USER magento|USER '$HOST_USER_NAME'|g' env/additional/phpstorm/Dockerfile
    sed -i '' 's|:=magento|:='$HOST_USER_NAME'|g' env/etc/apache/envvars
    sed -i '' 's|sshfs magento@|sshfs '$HOST_USER_NAME'@|g' env/Makefile
    sed -i '' 's|--user magento|--user '$HOST_USER_NAME'|g' env/Makefile

    mkdir nfs
    
    sed -i '' 's|  src-volume:||g' env/docker-compose.yml
    sed -i '' 's|  src-volume:||g' env/docker-compose.phpstorm.yml

echo "  src-volume:
    driver: local
    driver_opts:
      type: nfs
      o: addr=host.docker.internal,rw,nolock,soft,nfsvers=3 
      device: \":$HOST_PATH/nfs\"" >> env/docker-compose.yml

 echo "  src-volume:
    driver: local
    driver_opts:
      type: nfs
      o: addr=host.docker.internal,rw,nolock,soft,nfsvers=3 
      device: \":$HOST_PATH/nfs\"" >> env/docker-compose.phpstorm.yml     

    sudo renice -n -15 $(pgrep nfsd)
    sudo chown -R "$U":"$G" .

    echo ""
    echo "NFS settup done! spin up your containers using 'make up'"
    echo ""
    echo ""
    echo "==== To increase the priority of NFSD and gain some speed, run: ===="
    echo "sudo renice -n -15 \$(pgrep nfsd)"
    echo ""
    echo ""
fi
