#!/bin/sh

mkdir -p "/tmp/udo"
cd "/tmp/udo"
wget "http://www.tho-otto.de/download/udo-7.12-linux.tar.bz2"
tar xjf udo-7.12-linux.tar.bz2
UDO="/tmp/udo/udo"
export UDO
cd -

cd "/tmp"
wget "http://tho-otto.de/download/hcp-1.0.1-linux.tar.bz2"
tar xjf hcp-1.0.1-linux.tar.bz2
HCP="/tmp/hcp-1.0.1/bin/hcp"
export HCP
cd -
