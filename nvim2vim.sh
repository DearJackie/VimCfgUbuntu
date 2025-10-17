#!/bin/bash

# untility to convert the configuration folder from nvim into vim 

# make a copy of init.vim to vimrc
cp  ~/.config/nvim/init.vim ~/.config/nvim/vimrc

# create a link of current folder (~./config/nvim/) to ~/.vim)
ln -s ~/.config/nvim ~/.vim
