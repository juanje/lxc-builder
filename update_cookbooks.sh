#!/bin/bash

which bundle > /dev/null || ( echo "You need to install 'bundler'" ; exit 1 )
bundle install
bundle exec berks install --shims
tar --exclude-vcs -zcvf chef-solo.tar.gz ./cookbooks

