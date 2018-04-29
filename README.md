Base Ansible Role
=================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Common-Role.svg)](https://travis-ci.org/bbatsche/Ansible-Common-Role)
[![Ansible Galaxy](https://img.shields.io/ansible/role/8765.svg)](https://galaxy.ansible.com/bbatsche/Base)

This is a basic Ansible role that installs some common development tools and system configurations for doing full stack web development. It installs or sets up:

- Some common BASH profile tweaks
- Ruby
- Node.js
- Yarn
- Git
- Vim
- SASS
- Bower
- Grunt
- Gulp
- A swap file
- Sysctl settings
- The default timezone
- APT unattended upgrades

Role Variables
--------------

The role is designed to create a basic development environment out of the box, however there are some additional variables that can be set as required:

- `env_name` &mdash; Whether the server is going to be used for "development" or "production" or other. Default is "dev".
- `timezone` &mdash; What timezone the server is in. Default is "Etc/UTC".
- `console_user` &mdash; If you are setting up a new user for your server, you can use this value to install the BASH profile for that user. Default is `ansible_user`
- `swap_mb` &mdash; Size of swap file to create. Default is 0 (ie, no swap).
- `swap_path`&mdash; Location to store the swap file. Default is "/swap".
- `shmmax_percent` &mdash; Percentage of available memory to use for `kernel.shmmax`. Default is "50".
- `shmall_percent` &mdash; Percentage of available memory to use for `kernel.shmall`. Default is "50".
- `default_groups` &mdash; Groups to add the Ansible user or `console_user` to. Values are "web-admin" and "www-data".

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yml
- hosts: servers
  roles:
     - { role: bbatsche.Base }
```

License
-------

MIT

Testing
-------

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/).

To run the full suite of specs:

```bash
$ gem install bundler
$ bundle install
$ rake
```

The spec suite will target Ubuntu Trusty Tahr (14.04), Xenial Xerus (16.04), and Bionic Bever (18.04).

To see the available rake tasks (and specs):

```bash
$ rake -T
```

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency is tested independently via integration testing.
