#!/bin/bash

rm -fr cookbooks
mkdir cookbooks
pushd cookbooks
git clone -b "1.4.4"   --depth 1 git://github.com/opscode-cookbooks/apt.git          apt
git clone -b "1.5.2"   --depth 1 git://github.com/opscode-cookbooks/java.git         java
git clone -b "26fd53d" --depth 1 git://github.com/opscode-cookbooks/openssl.git      openssl
git clone -b "dbf5e44" --depth 1 git://github.com/opscode-cookbooks/postgresql.git   postgresql
git clone -b "1.2.0"   --depth 1 git://github.com/opscode-cookbooks/sudo.git         sudo
git clone -b "0.11.0"  --depth 1 git://github.com/edelight/chef-mongodb.git          mongodb
git clone -b "v0.9.0"  --depth 1 git://github.com/fnichol/chef-rvm.git               rvm
git clone -b "ba2e875" --depth 1 git://github.com/juanje/cookbook-conf.git           conf
git clone -b "HEAD"    --depth 1 git@github.com:juanje/cookbook-aentos-bootstrap.git aentos-bootstrap
popd
tar --exclude-vcs -zcvf chef-solo.tar.gz ./cookbooks

