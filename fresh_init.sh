#!/bin/bash

    mkdir $HOME/install
    cd $HOME/install

    apt install wget dpkg unzip
    #add PPA's
    sudo add-apt-repository ppa:inkscape.dev/stable ppa:webupd8team/atom

    #update
    apt update
    sudo apt full-upgrade
    #install apt packages
    apt install screen fonts-powerline tmux vim htop chromium-browser zsh g++ lcov git libmagickcore-dev libusb-1.0.0-dev libnss3-dev libglib2.0-dev libtool fprintd automake docker.io python python3 python-pip python-pip3 npm doxygen inkscape sl cmatrix term2
    #update
    apt update
    #non apt packages
    wget https://repo.continuum.io/archive/Anaconda2-5.1.0-Linux-x86_64.sh
    bash Anaconda-latest-Linux-x86_64.sh
    dpkg -i keybase_amd64.deb
    apt-get install -f
    wget https://release.gitkraken.com/linux/gitkraken-amd64.deb
    dpkg -i gitkraken-amd64.deb
    pip install setuptools

    wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    dpkg -i /path/to/discord.deb

#install apm packages
apm install atom-clock file-icons linter git-plus docblok atom-gdb-debugger language-cmake minimap teletype
#desktop environment
chsh -s $(which zsh)

#initialize dotfiles
cd $HOME
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
git clone https://github.com/solsane/configs && cd dotfiles && ./install
