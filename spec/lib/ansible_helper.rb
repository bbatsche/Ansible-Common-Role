require 'tempfile'
require 'shellwords'
require 'json'

class AnsibleHelper
  class << self
    def <<(vm)
      machines[vm.name] = vm
    end

    def [](name)
      machines[name]
    end

    def each(&block)
      machines.each_value(&block)
    end

    def machines
      @machines ||= {}
    end

    def inventory
      file = Tempfile.new("inventory")

      file << "[vagrant]\n"

      machines.each_value do |vm|
        file << vm.inventory_line << "\n" if vm.is_a? VagrantEnv
      end

      file << "\n[docker]\n"

      machines.each_value do |vm|
        file << vm.inventory_line << "\n" if vm.is_a? DockerEnv
      end

      file.close

      return file
    end

    def playbook(playbookFile, host = nil, extraVars = {})
      specDir      = File.expand_path(File.dirname(__FILE__) + "/../")
      playbookFile = Shellwords.escape(File.expand_path(playbookFile, specDir))

      host ||= ENV["TARGET_HOST"] ||= "all"

      cmd = "ansible-playbook -i #{inventory.path} -l #{host} #{playbookFile}"

      cmd << " -e #{extraVars.to_json.shellescape}" unless extraVars.empty?

      system cmd
    end

    def module(moduleName, host = nil, moduleArgs = "")
      host ||= ENV["TARGET_HOST"] ||= "all"

      invFile = inventory

      cmd = "ansible #{host} -i #{invFile.path} -m #{moduleName} --become"

      cmd << " -a #{moduleArgs.shellescape}" unless moduleArgs.strip.empty?

      system cmd
    end
  end
end
