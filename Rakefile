require 'rake'
require 'logger'
require 'rspec/core/rake_task'
require 'dotenv/tasks'

task :spec => 'spec:all'

class VagrantHelper
  include Singleton

  def initialize(logfile = ENV['VAGRANT_LOG'])
    @logFilename = logfile
    @logger = Logger.new @logFilename

    @logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.strftime "%H:%M:%S"

      "[#{date_format}] #{msg}\n"
    end
  end

  def cmd(cmd, name)
    puts "==> #{name} test environment (this may take several minutes)"
    IO.popen(cmd) do |io|
      io.each do |line|
        @logger.info line
      end
    end

    if !$?.success?
      raise "    #{name} test environment failed! See #{@logFilename} for more details."
    end
  end
end


namespace :vagrant do
  desc "Start the test vagrant environment (w/o provisioning)"
  task :up => :dotenv do
    VagrantHelper.instance.cmd("vagrant up --provider=virtualbox --no-color --no-provision #{ENV['HOST_NAME']}", "Booting")
  end

  desc "Provision the test vagrant environment"
  task :provision => :dotenv do
    VagrantHelper.instance.cmd("vagrant provision #{ENV['HOST_NAME']}", "Provisioning")
  end

  desc "Destroy the test vagrant environment"
  task :destroy => :dotenv do
    VagrantHelper.instance.cmd("vagrant destroy --force #{ENV['HOST_NAME']}", "Destroying")
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
