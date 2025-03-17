#!/bin/bash
#
# This is the start up script to set up the vim configuration
# You can run this script in any directory as it uses absolute path
#
#
# install the universal ctags
echo ".....installing univeral-ctags...."
sudo apt-get install universal-ctags 

# install the GNU Global for gtags
echo ".....installing GNU global and gtags...."
sudo apt-get install global


# copy the configuration to required location under $HOME with directory name .vim
# create a new directory if not exist
dest_path=$HOME/.vim
echo ".....create and copy configurations to $dest_path..."

# store the script directory in a variable
#script_dir=$(dirname $0)  # relative path

# store the absolute path of the script directory in a variable
script_dir=$(realpath $(dirname $0))

echo ".....the script is located in: $script_dir" 

mkdir -p $dest_path

cp -r $script_dir/*  $dest_path

echo ".....setting up completed!"
