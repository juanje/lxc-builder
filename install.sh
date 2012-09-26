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
    cp lxc-provision /usr/local/bin/lxc-provision
fi
