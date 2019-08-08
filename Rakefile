require "rake"
require "rspec/core/rake_task"
require_relative "spec/lib/environments"

namespace :environment do
  upTasks        = []
  downTasks      = []
  destroyTasks   = []
  provisionTasks = []

  AnsibleHelper.each do |vm|
    namespace vm.name.to_sym do
      upTasks        << :"#{vm.name}:up"
      downTasks      << :"#{vm.name}:down"
      destroyTasks   << :"#{vm.name}:destroy"
      provisionTasks << :"#{vm.name}:provision"

      desc "Boot #{vm.name} test environment"
      task :up do
        puts "Booting #{vm.name} test environment"

        begin
          vm.up
        rescue ExecError => e
          puts e.message
          puts e.output.join("\n")
          exit 1
        end
      end

      desc "Shut down #{vm.name} test environment"
      task :down do
        puts "Shutting down #{vm.name} test environment"

        begin
          vm.down
        rescue ExecError => e
          puts e.message
          puts e.output.join("\n")
          exit 1
        end
      end

      desc "Destroy #{vm.name} test environment"
      task :destroy => :down do
        puts "Destroying #{vm.name} test environment"

        begin
          vm.destroy
        rescue ExecError => e
          puts e.message
          puts e.output.join("\n")
          exit 1
        end
      end

      desc "Provision #{vm.name} test environment"
      task :provision => :up do
        puts "Provisioning #{vm.name} test environment"

        begin
          vm.provision
        rescue ExecError => e
          puts e.message
          puts e.output.join("\n")
          exit 1
        end
      end
    end
  end

  task :"up:all"        => upTasks
  task :"down:all"      => downTasks
  task :"destroy:all"   => destroyTasks
  task :"provision:all" => provisionTasks

  desc "Boot all test environments"
  task :up => :"up:all"

  desc "Shut down all test environments"
  task :down => :"down:all"

  desc "Destroy all test environments"
  task :destroy => :"destroy:all"

  desc "Provision all test environments"
  task :provision => :"provision:all"
end

namespace :spec do
  specTasks = []

  AnsibleHelper.each do |vm|
    namespace vm.name.to_sym do
      vmTasks = []
      Dir.glob("./spec/*-spec.rb").each do |file|
        spec = File.basename file

        # Trim off "-spec.rb" and add to list
        taskName = spec[0..-9]
        vmTasks << :"#{vm.name}:#{taskName}"

        desc "Run #{taskName} spec in #{vm.name}"
        RSpec::Core::RakeTask.new(taskName.to_sym => [:init]) do |task|
          ENV["TARGET_HOST"] = vm.name
          task.pattern = file
        end
      end

      task :all => vmTasks

      specTasks << :"#{vm.name}:all"
    end

    desc "Run all specs for #{vm.name}"
    task vm.name.to_sym => "#{vm.name}:all"
  end

  task :all => specTasks
end

namespace :init do
  desc "Symbolic link files and templates into the spec/playbooks directory"
  task :links do
    ["files", "library", "templates", "filter_plugins"].each do |f|
      path = "spec/playbooks/#{f}"
      next if File.symlink? path or !File.exist? f
      raise "File #{path} exists and is not a symlink! Don't know what to do" if File.exist? path

      File.symlink "../../#{f}", path
    end
  end

  task :default => [:links]
end

namespace :ansible do
  playbookTasks = []

  AnsibleHelper.each do |vm|
    playbookTasks << "playbook:#{vm.name}"

    desc "Run an Ansible module in the #{vm.name} environment"
    task vm.name.to_sym, [:module, :args] do |t, args|
      args.with_defaults :args => ""

      AnsibleHelper.module(args.module, vm.name, args.args)
    end

    namespace :playbook do
      desc "Run an Ansible playbook in the #{vm.name} environment"
      task vm.name.to_sym, [:filename] do |t, args|
        filename = File.expand_path(args.filename, File.dirname(__FILE__))

        AnsibleHelper.playbook(filename, vm.name)
      end
    end
  end

  desc "Run an Ansible playbook in all environments"
  task :playbook, [:filename] do |t, args|
    filename = File.expand_path(args.filename, File.dirname(__FILE__))

    AnsibleHelper.playbook filename
  end
end

desc "Run all specs"
task :spec    => "spec:all"

desc "Initialize test environment files"
task :init    => "init:default"

task :default => ["environment:up", "environment:provision", "spec:all", "environment:destroy"]
