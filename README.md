Base Ansible Role
=================

[![Build Status](https://travis-ci.org/bbatsche/Ansible-Common-Role.svg)](https://travis-ci.org/bbatsche/Ansible-Common-Role)

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

- `app_env` &mdash; Whether the server is going to be used for "development" or "production" or other. Default is "dev".
- `timezone` &mdash; What timezone the server is in. Default is "Etc/UTC".
- `console_user` &mdash; If you are setting up a new user for your server, you can use this value to install the BASH profile for that user. Default is `ansible_user_id`

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: bbatsche.Base }

Testing
-------

Included with this role is a set of specs for testing each task individually or as a whole. To run these tests you will first need to have [Vagrant](https://www.vagrantup.com/) and [VirtualBox](https://www.virtualbox.org/) installed. The spec files are written using [Serverspec](http://serverspec.org/) so you will need Ruby and [Bundler](http://bundler.io/). _**Note:** To keep things nicely encapsulated, everything is run through `rake`, including Vagrant itself. Because of this, your version of bundler must match Vagrant's version requirements. As of this writing (Vagrant version 1.8.1) that means your version of bundler must be between 1.5.2 and 1.10.6._

To run the full suite of specs:

```bash
$ gem install bundler -v 1.10.6
$ bundle install
$ rake
```

To see the available rake tasks (and specs):

```bash
$ rake -T
```

There are several rake tasks for interacting with the test environment, including:

- `rake vagrant:up` &mdash; Boot the test environment (_**Note:** This will **not** run any provisioning tasks._)
- `rake vagrant:provision` &mdash; Provision the test environment
- `rake vagrant:destroy` &mdash; Destroy the test environment
- `rake vagrant[cmd]` &mdash; Run some arbitrary Vagrant command in the test environment. For example, to log in to the test environment run: `rake vagrant[ssh]`

These specs are **not** meant to test for idempotence. They are meant to check that the specified tasks perform their expected steps. Idempotency can be tested independently as a form of integration testing.

License
-------

MIT

