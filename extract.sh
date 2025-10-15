#!/bin/bash

# untility function to decompress various files in linux in place
extract() {
    local file=$1

    echo "extracting file: $file"

    if [ ! -f "$file" ] ; then
        echo "'$file' does not exist."
        return 1
    fi

    case "$file" in
        *.tar.bz2)   tar xvjf "$file"           ;;
        *.tar.xz)    tar xvJf "$file"           ;;
        *.tar.gz)    tar xvzf "$file"           ;;
        *.bz2)       bunzip2 "$file"            ;;
        *.rar)       rar x "$file"              ;;
        *.gz)        gunzip "$file"             ;;
        *.tar)       tar xvf "$file"            ;;
        *.tbz2)      tar xvjf "$file"           ;;
        *.tgz)       tar xvzf "$file"           ;;
        *.zip)       unzip -q "$file"           ;;
        *.Z)         uncompress "$file"         ;;
        *.xz)        xz -d "$file"              ;;
        *.7z)        7z x "$file"               ;;
        *.a)         ar x "$file"               ;;
        *)    echo "Unable to extract '$file'." ;;
    esac

    echo "extracting file: $file completed!"
}

# call the function
extract $1
