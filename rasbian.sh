#!/usr/bin/env  bash

# create         03.08.2020
# author         rx
# description    auto-setup basic system-supporting utils, in order to setup your raspberry pi quickly

DOWNLOAD_DIR="~/src"

function reset() {
  mkdir -p $DOWNLOAD_DIR
  cd $DOWNLOAD_DIR;
}

# install libevent
reset
wget http://ftpmirror.gnu.org/libtool/libtool-2.4.6.tar.gz
tar -zxf libtool-2.4.6.tar.gz
cd libtool-2.4.6
./configure
make
sudo make install
sudo ldconfig

# install ncurses
reset
wget https://invisible-mirror.net/archives/ncurses/ncurses-6.2.tar.gz
tar -zxf ncurses-6.2.tar.gz
cd ncurses-6.2
./configure
make &&  make install
