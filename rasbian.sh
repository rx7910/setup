#!/usr/bin/env  bash

# create         03.08.2020
# author         rx
# description    auto-setup basic system-supporting utils, in order to setup your raspberry pi quickly

DOWNLOAD_DIR="~/src"

function reset() {
  mkdir -p $DOWNLOAD_DIR
  cd $DOWNLOAD_DIR;
}

# automake
reset
wget http://mirrors.kernel.org/gnu/automake/automake-1.11.tar.gz \
&& tar xzvf automake-1.11.tar.gz \
&& cd automake-1.11 \
&& ./configure –prefix=/usr/local
make && sudo make install

# autoconfig
reset
wget http://mirrors.kernel.org/gnu/autoconf/autoconf-latest.tar.gz
tar -zxf autoconf-latest.tar.gz
cd autoconf-latest
./configure –prefix=/usr/local
make && sudo make install

# libtool
reset
wget http://mirrors.kernel.org/gnu/libtool/libtool-2.2.6b.tar.gz \
&& tar xzvf libtool-2.2.6b.tar.gz \
&& cd libtool-2.2.6b \
&& ./configure –prefix=/usr/local
make && make install

# libevent
reset
wget http://www.monkey.org/~provos/libevent-2.0.10-stable.tar.gz
tar zxvf libevent-2.0.10-stable.tar.gz
cd libevent-2.0.10-stable
./configure –prefix=/usr/local
make
sudo make install
sudo ldconfig

# install ncurses
reset
wget https://invisible-mirror.net/archives/ncurses/ncurses-6.2.tar.gz
tar -zxf ncurses-6.2.tar.gz
cd ncurses-6.2
./configure –prefix=/usr/local
make && sudo make install

# tmux
reset
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make

