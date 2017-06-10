#!/bin/sh
# Usage: install-cross-mint.sh <package name> [<package name>...]

sudo add-apt-repository ppa:vriviere/ppa
sudo apt-get update
sudo apt-get install -y $*
