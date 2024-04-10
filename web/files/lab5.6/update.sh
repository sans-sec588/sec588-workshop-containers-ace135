#!/bin/bash
sudo apt update -y
#sudo apt dist-upgrade -y
sudo apt install freerdp2-x11 freerdp2-dev -y
cd /opt/hydra
make clean
./configure
make
sudo make install

