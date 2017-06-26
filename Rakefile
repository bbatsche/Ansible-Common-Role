require "rake"
require "yaml"
require "rspec/core/rake_task"
require_relative "spec/lib/ansible_helper"
require_relative "spec/lib/vagrant_helper"

namespace :vagrant do
  desc "Boot the test environment (w/o provisioning)"
  task :up do
    VagrantHelper.instance.cmd(:up, ["--provider=virtualbox", "--no-color", "--no-provision"])
  end

  desc "Provision the test environment"
  task :provision do
    VagrantHelper.instance.cmd :provision
  end

  desc "Destroy the test environment"
  task :destroy do
    VagrantHelper.instance.cmd(:destroy, ["--force"])
  end
end

task :spec => "spec:all"

namespace :spec do
  tasks = []

  VagrantHelper::MACHINES.each_key do |vm|
    vmTasks = []

    Dir.glob('./spec/*-spec.rb').each do |file|
      spec = File.basename file

      # Trim off "-spec.rb" and add to list
      taskName = spec[0..-9]
      fullName = "#{vm.to_s}:#{taskName}"
      vmTasks << fullName

      desc "Run serverspec tests for #{taskName} against #{vm.to_s}"
      RSpec::Core::RakeTask.new(fullName.to_sym => [:init]) do |t|
        ENV["TARGET_HOST"] = VagrantHelper::MACHINES[vm]
        t.pattern = "./spec/#{taskName}-spec.rb"
      end
    end

    task vm => vmTasks
    tasks.concat vmTasks
  end

  task :all     => tasks
  task :default => :all
end

VagrantHelper::MACHINES.each do |name, vm|
  desc "Run an Ansible module in the #{name.to_s} VM"
  task :"ansible:#{name.to_s}", [:module, :args] do |t, args|
    args.with_defaults :args => ""

    AnsibleHelper.instance.cmd(args.module, vm, args.args)
  end

  namespace :"ansible:#{name.to_s}" do
    desc "Run an Ansible playbook in the #{name.to_s} VM"
    task :playbook, [:filename] do |t, args|
      filename = File.expand_path(args.filename, File.dirname(__FILE__))

      AnsibleHelper.instance.playbook(filename, vm)
    end
  end
end


task :init => "init:default"

namespace :init do
  desc "Symbolic link files and templates into the spec/playbooks directory"
  task :links do
    ["files", "library", "templates"].each do |f|
      path = "spec/playbooks/#{f}"
      next if File.symlink? path or !File.exist? f
      raise "File #{path} exists and is not a symlink! Don't know what to do" if File.exist? path

      File.symlink "../../#{f}", path
    end
  end

  desc "Copy handlers into spec and Travis playbooks"
  task :handlers do
    playbooks = Dir.glob "spec/playbooks/*.yml"
    playbooks << "travis-playbook.yml"

    playbooks.each do |file|
      dir = File.dirname file
      book = YAML.load(File.read(file))

      next unless book[0].has_key? "handlers"

      new_includes = []
      new_handlers = []

      book[0]["handlers"].each do |handler|
        next unless handler.has_key? "include"

        new_includes << handler
        handler_path = File.expand_path dir + "/" + handler["include"]
        handler_content = YAML.load(File.read(handler_path))

        next if handler_content.nil?

        new_handlers += handler_content
      end

      book[0]["handlers"] = new_includes + new_handlers

      File.write file, book.to_yaml
    end
  end

  task :default => [:links, :handlers]
end

task :default => [:"vagrant:up", :"vagrant:provision", :"spec:all", :"vagrant:destroy"]
