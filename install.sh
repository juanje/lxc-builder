#!/bin/bash

if [ "$(id -u)" != "0" ]; then
    echo "This script should be run as 'root'. Try with sudo"
    exit 1
fi

if [ -f chef-solo.tar.gz ]; then
    echo -ne "Copy the cookbooks into the LXC cache:\t"
    cp -v chef-solo.tar.gz /var/cache/lxc/chef-solo.tar.gz
fi

if [ -x lxc-aentos ]; then
    echo -ne "Copy the Aentos's template to the LXC templates:\t"
    cp -v lxc-aentos /usr/lib/lxc/templates/lxc-aentos
fi

if [ -x lxc-provision ]; then
    mkdir -p /usr/local/bin/
    echo -ne "Copy the lxc-provision command to your PATH:\t"
    cp -v lxc-provision /usr/local/bin/lxc-provision
fi

if [ -x lxc-ssh ]; then
    mkdir -p /usr/local/bin/
    echo -ne "Copy the lxc-ssh command to your PATH:\t"
    cp -v lxc-ssh /usr/local/bin/lxc-ssh
fi
