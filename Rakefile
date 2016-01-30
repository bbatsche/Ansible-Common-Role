require "rake"
require "rspec/core/rake_task"
require "dotenv/tasks"
require_relative "spec/lib/ansible_helper"
require_relative "spec/lib/vagrant_helper"

desc "Run an arbitrary vagrant command for the test environment"
task :vagrant, [:cmd] => [:dotenv] do |t, args|
  exec "vagrant #{args.cmd} #{ENV['HOST_NAME']}"
end

namespace :vagrant do
  desc "Boot the test environment (w/o provisioning)"
  task :up => :dotenv do
    VagrantHelper.instance.cmd("Booting", "up --provider=virtualbox --no-color --no-provision")
  end

  desc "Provision the test environment"
  task :provision => :dotenv do
    VagrantHelper.instance.cmd("Provisioning", "provision")
  end

  desc "Destroy the test environment"
  task :destroy => :dotenv do
    VagrantHelper.instance.cmd("Destroying", "destroy --force")
  end
end

task :spec => "spec:all"

namespace :spec do
  tasks = []

  Dir.glob('./spec/*-spec.rb').each do |file|
    spec = File.basename file

    # Trim off "-spec.rb" and add to list
    tasks << spec[0..-9]
  end

  task :all     => tasks
  task :default => :all

  tasks.each do |taskName|
    desc "Run serverspec tests for #{taskName}"

    RSpec::Core::RakeTask.new(taskName.to_sym => [:dotenv, :"vagrant:up"]) do |t|
      t.pattern = "./spec/#{taskName}-spec.rb"
    end
  end
end

desc "Run an arbitrary Ansible module in the test environment"
task :ansible, [:module, :args] => [:"vagrant:up"] do |t, args|
  args.with_defaults :args => ""

  AnsibleHelper.instance.cmd args.module, args.args
end

namespace :ansible do
  desc "Run an arbitrary Ansible playbook in the test environment"
  task :playbook, [:filename, :vars] => [:"vagrant:up"] do |t, args|
    args.with_defaults :vars => ""

    AnsibleHelper.instance.playbook args.filename, args.vars
  end
end

task :default => [:"vagrant:up", :"vagrant:provision", :"spec:all", :"vagrant:destroy"]
