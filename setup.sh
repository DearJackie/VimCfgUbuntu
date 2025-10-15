#!/bin/bash
#
# This is the start up script to set up the vim configuration
# You can run this script in any directory as it uses absolute path
#
#
# install vim-gtk3
echo ".....installing vim-gtk3...."
sudo apt-get install vim-gtk3

# install the universal ctags
echo ".....installing univeral-ctags...."
sudo apt-get install universal-ctags 

# install the GNU Global for gtags
echo ".....installing GNU global and gtags...."
sudo apt-get install global

# install ripgrep (rg), which is to replace grep to find content inside files, much faster
echo ".....installing ripgrep...."
sudo apt-get install ripgrep

# install fd, which is to replace find to find files and directories, much faster
echo ".....installing fd...."
sudo apt install fd-find

# link fd as the default command for the fdfind command, as 'fd' name is used by another name
sudo ln -s $(which fdfind) /usr/local/bin/fd

# install git
echo ".....installing git...."
sudo apt install git git-lfs

# add support to compress/decompress .7z and .rar files (optional)
#echo ".....installing 7z...."
#sudo apt install p7zip-full p7zip-rar

# install the fzf fuzzer finder, which is a filter from list, install LATEST from github
echo ".....installing fzf...."
#sudo apt install fzf   # ubuntu repo is not the latest version
# get the latest version from github source, after installation, you must reload .bashrc as prompted, otherwise, you
# can't find 'fzf' command
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
cd fzf
./install

# set fzf default command as "fdfind", generate input for fzf using fd-find
#export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'
echo "export FZF_DEFAULT_COMMAND='fd --type file'" >> ~/.bashrc
echo 'export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"' >> ~/.bashrc

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
