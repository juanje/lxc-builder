Description
===========

This is a set of scripts to build a LXC container and prepare it to be provisioned by `chef-solo`.

This is meant to work with Debain and Ubuntu containers to be bootstraped with Chef. It also comes with a list of cookbooks to be used by the container in order to bootstrap an Rails project by any of the Aentos developers.


Install
=======

To install the scripts you need to have installed in a Ubuntu/Debian box with the following dependencies:

* `lxc`
* `rake` (it doesn't matter if vía system packages or gems)

Now you need to run:

```
$ sudo rake
```

NOTE: It's important to run the `rake` with `sudo` or as a root user.

This will download the cookbooks, will create a tarball to be used by the `chef-solo` and will copy the tarball and the script to your system.
You can see the rest of the rake tasks by doing:

```
$ rake -T
```

Usage
=====

First you need to run the `sudo rake`. Then you can create a LXC container with `lxc-build-project`:

```
$ sudo lxc-build-project -n <container-name> [-u|--distro <username>] [-D|--distro <distro>] [-- <template params>]
```

Obviously, the `<container-name>` you choose will be the one use to refer to the container. This parameter must be provider.
The `<username>` is the name of the user you want to be created inside the container to manage it. It's optional but highly recommended to be provided.
If you are going to use the boostrap cookbook, **it's very important that the user you choose be the same in both cases** (the container and the cookbook). See the cookbook's attributes for more info.

The `<distro>` could be either `debian` or `ubuntu`. The default option is `debian`.

You can also pass some parameters to the `lxc-create` after `--`, like the IP the container should have:

```
$ sudo lxc-build-project -n superproject -u aentos -- -i 10.0.3.51
```

After you create the container you need to provision it by doing:

```
$ lxc-provision -n superproject
```

You also can use `lxc-console` or normal ssh connection to work inside the container. To connect via ssh with the container without password you can use a private key copied to `/var/cache/lxc/id_project_[container-name]` for this purpose.
There is also a handy command `lxc-ssh` which do the job. Here is how you can use it:

```
$ lxc-ssh -n superproject
```

In case you need it, the password for the `aentos` user is `aentos`.


License and Author
==================

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
