#!/bin/bash

set -e  # Exit after any error

rm -fr cookbooks
mkdir cookbooks
pushd cookbooks
git clone -b "1.4.4"   git://github.com/opscode-cookbooks/apt.git          apt
git clone -b "1.5.2"   git://github.com/opscode-cookbooks/java.git         java
git clone -b "master"  git://github.com/opscode-cookbooks/openssl.git      openssl
git clone -b "master"  git://github.com/opscode-cookbooks/postgresql.git   postgresql
git clone -b "1.2.0"   git://github.com/opscode-cookbooks/sudo.git         sudo
git clone -b "0.11.0"  git://github.com/edelight/chef-mongodb.git          mongodb
git clone -b "v0.9.0"  git://github.com/fnichol/chef-rvm.git               rvm
git clone -b "master"  git://github.com/juanje/cookbook-conf.git           conf
git clone -b "master"  https://github.com/juanje/cookbook-aentos-bootstrap.git aentos-bootstrap
popd

tar --exclude-vcs -zcvf chef-solo.tar.gz cookbooks
