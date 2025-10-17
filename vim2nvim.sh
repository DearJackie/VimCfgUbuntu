#!/bin/bash

# untility to convert the configuration folder from vim into nvim 

# make a copy of vimrc to init.vim
cp ~/.vim/vimrc ~/.vim/init.vim

# create a link from ~/.vim to ~/.config/nvim
ln -s ~/.vim  ~/.config/nvim
