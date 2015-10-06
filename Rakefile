require 'rake'
require 'rspec/core/rake_task'
require 'dotenv/tasks'

task :spec => 'spec:all'

namespace :vagrant do
  desc "Start the test vagrant environment (w/o provisioning)"
  task :up => :dotenv do
    system "vagrant up --provider=virtualbox --no-provision #{ENV['HOST_NAME']}"
  end

  desc "Provision the test vagrant environment"
  task :provision => :dotenv do
    system "vagrant provision #{ENV['HOST_NAME']}"
  end

  desc "Destroy the test vagrant environment"
  task :destroy => :dotenv do
    system "vagrant destroy --force #{ENV['HOST_NAME']}"
  end
end

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

    RSpec::Core::RakeTask.new(taskName.to_sym => :dotenv) do |t|
      t.pattern = "./spec/#{taskName}-spec.rb"
    end
  end
end

task :default => ["vagrant:up", "vagrant:provision", "spec:all", "vagrant:destroy"]
