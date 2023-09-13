#!/bin/bash

brew_file_loc=$HOME/Dev/personal/nix-config/mac/brew_dump
cd /tmp
brew bundle dump
mv Brewfile "$brew_file_loc"
cd $(dirname $brew_file_loc)

# upload
git add "$brew_file_loc"
git commit -m "brew backup"
git push origin master
