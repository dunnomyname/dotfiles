#!/bin/bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function updateConfig() {
    rsync --exclude ".git/" \
        --exclude ".DS_Store" \
        --exclude "bootstrap-linux.sh" \
        --exclude "setup-linux.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        -avh --no-perms . "$HOME"/;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
    updateConfig;
else
    read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
    echo "";
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        updateConfig;
    fi;
fi;

unset updateConfig;