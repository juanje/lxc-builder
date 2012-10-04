Description
===========

A LXC template with Chef cookbooks to create a development enviroment for Aentos projects

This is a template for LXC plus a few utilities to bootstrap a Aentos project using Chef.

The template is functional, but still need some love. This also depends on the Chef cookbooks, which make the real bootstraping.


Install
=======

There is a very poor script with place all you need in place called `install.sh`.

You need to have LXC installed on a Ubuntu box (preferably Ubuntu Precise) and then run this script as a `root`. This will copy the template to `/usr/lib/lxc/templates/lxc-aentos` to be used by `lxc-create`, the tarball with the cookbooks to `/var/cache/lxc/chef-solo.tar.gz` and a simple command to make the provisioning inside the container to `/usr/local/bin/lxc-provision`.

Usage
=====

First you need to run the `install.sh` script. Then you create a normal LXC container with `lxc-create`, but with the following parameters:

```
$ sudo lxc-create -t aentos -n [container-name]
```

Obviously, the `[container-name]` you choose will be the one use to refer to the container.

You can also pass some parameters to the themplate, like the IP the container should have, after `--`:

```
$ sudo lxc-create -t aentos -n superproject -- -i 10.0.3.51
```

After you create the container you need to provision it by doing:

```
$ lxc-provision superproject
```

or (if you have not dnsmasq working with you resolvconf):

```
$ lxc-provision 10.0.3.51
```

You also can use `lxc-console` or normal ssh connection to work inside the container. To connect via ssh with the container without password you can use a private key copied to `/var/cache/lxc/id\_aentos\_[container-name]` for this purpose.
There is also a handy command `lxc-ssh` which do the job. Here is how you can use it:

```
$ lxc-ssh superproject
```

In case you need it, the password for the `aentos` user is `aentos`.


License and Author
==================

The content of this repo but the LXC template (`lxc-aentos`), which is based in another one with a GPL-v2 license and should be shared under the same license, is released under the following license and credits:

Author:: Juanje Ojeda (<juanje.ojeda@gmail.com>)

Copyright:: 2012, Aentos

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
