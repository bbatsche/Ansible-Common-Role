# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure('2') do |config|
  config.vm.define 'trusty' do |trusty|
    trusty.vm.box = 'ubuntu/trusty64'
  end

  config.vm.define 'xenial' do |xenial|
    xenial.vm.box = 'ubuntu/xenial64'
  end

  config.vm.define 'bionic' do |xenial|
    xenial.vm.box = 'ubuntu/bionic64'
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provision-playbook.yml"

    ansible.compatibility_mode = "2.0"
  end

  if Vagrant.has_plugin? 'vagrant-vbguest'
    config.vbguest.no_install = true
  end
end
