#!/bin/bash

## install net-tools
sudo yum install -y net-tools

## install gnome desktop
sudo yum groupinstall -y "X Window System"
sudo yum groupinstall -y "GNOME Desktop"

## install develop enviroment
sudo yum groupinstall -y "Development Tools"
sudo yum install -y python-devel python3-devel ncurses-devel git zsh wget curl
sudo yum remove -y vim
sudo yum install -y epel-release
sudo yum install -y autojump-zsh autojump-fish htop
sudo yum remove -y epel-release
export http_proxy="http://192.168.139.1:1080"
export https_proxy="http://192.168.139.1:1080"

## install vim
git clone https://github.com/vim/vim.git
cd vim
./configure \
 --disable-nls \
 --enable-cscope \
 --enable-gui=no \
 --enable-multibyte  \
 --enable-pythoninterp \
 --enable-python3interp \
 --enable-rubyinterp \
 --with-features=huge  \
 --with-python-config-dir=/usr/lib64/python2.7/config \
 --with-python-config-dir=/usr/lib64/python3.6/config-3.6m-x86_64-linux-gnu \
 --with-tlib=ncurses \
 --without-x
make && sudo make install
cd ..
rm -rf vim

## install oh-my-zsh
sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
chsh -s /bin/zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
wget https://raw.githubusercontent.com/caiogondim/bullet-train-oh-my-zsh-theme/master/bullet-train.zsh-theme
mv ./bullet-train.zsh-theme ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

## install tmux
git clone https://github.com/tmux/tmux.git
cd tmux
sh autogen.sh
./configure && make
sudo make install
cd ..
rm -rf tmux

## import config file
mv ./.zshrc ${ZSH_CUSTOM:-~/}
mv ./.vimrc ${ZSH_CUSTOM:-~/}
mv ./.tmux.conf ${ZSH_CUSTOM:-~/}

## change shell
/bin/zsh
sudo chown ash /mnt/hgfs