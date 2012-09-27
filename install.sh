#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script should be run as 'root'. Try with sudo"
    exit 1
fi

if [ -f chef-solo.tar.gz ]; then
    cp chef-solo.tar.gz /var/cache/lxc/chef-solo.tar.gz
fi

if [ -x lxc-aentos ]; then
    cp lxc-aentos /usr/lib/lxc/templates/lxc-aentos
fi

if [ -x lxc-provision ]; then
    mkdir -p /usr/local/bin/
    cp lxc-provision /usr/local/bin/lxc-provision
fi

if [ -f insecure_private_key ]; then
    echo -ne "Copy the SSH key to the LXC cache:\t"
    cp -v insecure_private_key /var/cache/lxc/insecure_private_key
fi
