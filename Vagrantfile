# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.define 'trusty' do |trusty|
    trusty.vm.box = 'ubuntu/trusty64'
  end

  config.vm.define 'xenial' do |xenial|
    xenial.vm.box = 'ubuntu/xenial64'
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provision-playbook.yml"

    ansible.compatibility_mode = "2.0"

    ansible.skip_tags = ["timezone", "sysctl", "ruby", "node"]
  end

  if Vagrant.has_plugin? 'vagrant-cachier'
    config.cache.scope = :box

    config.cache.enable :apt
    config.cache.enable :apt_lists
    config.cache.enable :apt_cacher
    config.cache.enable :composer
    config.cache.enable :bower
    config.cache.enable :npm
    config.cache.enable :gem
  end

  if Vagrant.has_plugin? 'vagrant-vbguest'
    config.vbguest.no_install = true
  end
end
