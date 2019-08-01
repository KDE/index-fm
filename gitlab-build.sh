#!/bin/bash

sudo apt-get update; sudo apt-get install sshpass linux-modules-$(uname -r) -y
sudo apt-get install fuse -y ; sudo modprobe fuse 

wget https://raw.githubusercontent.com/Nitrux/nitrux-repository-util/master/build-index-fm.sh

chmod +x build-index-fm.sh

./build-index-fm.sh


export SSHPASS=$DEPLOY_PASS

sshpass -e scp -q -o stricthostkeychecking=no *.AppImage $DEPLOY_USER@$DEPLOY_HOST:$DEPLOY_PATH
#sshpass -e ssh $DEPLOY_USER@$DEPLOY_HOST 'bash /home/packager/repositories/nomad-desktop/repositories_util.sh'
