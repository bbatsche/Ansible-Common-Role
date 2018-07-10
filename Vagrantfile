# -*- mode: ruby -*-
# vi: set ft=ruby :

require "yaml"

default_config_file = File.join(File.dirname(__FILE__), "config.yml.dist")
local_config_file   = File.join(File.dirname(__FILE__), "config.yml")

config_data = YAML.load_file default_config_file
config_data = Vagrant::Util::DeepMerge.deep_merge(config_data, YAML.load_file(local_config_file)) if File.exists? local_config_file

Vagrant.configure("2") do |config|
  ["trusty", "xenial", "bionic"].each do |distro|
    config.vm.define distro do |target_env|
      vm_config = Vagrant::Util::DeepMerge.deep_merge config_data["vm"]["global"], config_data["vm"][distro]

      target_env.vm.box = vm_config["box"]

      target_env.vm.provider :virtualbox do |vb, override|
        vb.memory = vm_config["ram"]
        vb.cpus   = vm_config["num_cpus"]

        vb.linked_clone = true

        vb.customize ["modifyvm", :id, "--uartmode1", "disconnected"]
      end

      target_env.vm.provider :vmware_fusion do |vmw, override|
        vmw.vmx["memsize"]  = vm_config["ram"]
        vmw.vmx["numvcpus"] = vm_config["num_cpus"]
      end

      target_env.vm.provider :parallels do |p, override|
        p.memory = vm_config["ram"]
        p.cpus   = vm_config["num_cpus"]

        p.check_guest_tools  = false
        p.update_guest_tools = false
      end
    end
  end

  config.vm.provision :ansible do |ansible|
    ansible.playbook = "provision-playbook.yml"

    ansible.compatibility_mode = "2.0"

    ansible.extra_vars = config_data["ansible"]["vars"]

    ansible.groups = {
      "vagrant" => ["trusty", "xenial", "bionic"]
    }

    ansible.groups["vagrant:vars"] = { "ansible_python_interpreter" => "/usr/bin/python3" } if ENV["ANSIBLE_PYTHON_VERSION"] == "3"
  end

  if Vagrant.has_plugin? 'vagrant-vbguest'
    config.vbguest.no_install = true
  end
end
