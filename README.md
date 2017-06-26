Base Ansible Role
=================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Common-Role.svg)](https://travis-ci.org/bbatsche/Ansible-Common-Role)
[![Ansible Galaxy](https://img.shields.io/ansible/role/10938.svg)](https://galaxy.ansible.com/bbatsche/Base)

This is a basic Ansible role that installs some common development tools and system configurations for doing full stack web development. It installs or sets up:

- Some common BASH profile tweaks
- Ruby
- Node.js
- Git
- SASS
- Bower
- Grunt
- Gulp
- A 1GB swap file
- Sysctl settings
- The server timezone
- APT unattended upgrades

Role Variables
--------------

The role is designed to create a basic development environment out of the box, however there are some additional variables that can be set as required:

- `env_name` &mdash; Whether the server is going to be used for "development" or "production" or other. Default is "dev".
- `timezone` &mdash; What timezone the server is in. Default is "Etc/UTC".
- `console_user` &mdash; If you are setting up a new user for your server, you can use this value to install the BASH profile for that user. Default is `ansible_ssh_user`

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

The spec suite will target both Ubuntul Trusty Tahr (14.04) and Xenial Xerus (16.04).

To see the available rake tasks (and specs):

```bash
$ rake -T
```

There are several rake tasks for interacting with the test environment, including:

- `rake vagrant:up` &mdash; Boot the test environment (_**Note:** This will **not** run any provisioning tasks._)
- `rake vagrant:provision` &mdash; Provision the test environment
- `rake vagrant:destroy` &mdash; Destroy the test environment

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency can be tested independently as a form of integration testing.
