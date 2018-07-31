Base Ansible Role
=================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Common-Role.svg)](https://travis-ci.org/bbatsche/Ansible-Common-Role)
[![License](https://img.shields.io/github/license/bbatsche/Ansible-Common-Role.svg)](LICENSE)
[![Role Name](https://img.shields.io/ansible/role/27191.svg)](https://galaxy.ansible.com/bbatsche/Base)
[![Release Version](https://img.shields.io/github/tag/bbatsche/Ansible-Common-Role.svg)](https://galaxy.ansible.com/bbatsche/Base)
[![Downloads](https://img.shields.io/ansible/role/d/27191.svg)](https://galaxy.ansible.com/bbatsche/Base)

This Ansible role does some simple configuration and settings for a system doing web development. It does the following:

- Updates APT cache
- Installs Filesystem ACLs
- Installs Direnv
- Configures the Bash profile with some helpful command aliases and settings
- Configures Vim
- Tweaks Sysctl settings
- Creates a `web-admin` group and assigns it to the current user

Role Variables
--------------

- `console_user` &mdash; If you are setting up a new user for your server, you can use this value to install the BASH profile for that user. Default is `ansible_user`
- `shmmax_percent` &mdash; Percentage of available memory to use for `kernel.shmmax`. Default is "50".
- `shmall_percent` &mdash; Percentage of available memory to use for `kernel.shmall`. Default is "50".
- `default_groups` &mdash; Groups to add the Ansible user or `console_user` to. Values are "web-admin" and "www-data".

Example Playbook
----------------

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
