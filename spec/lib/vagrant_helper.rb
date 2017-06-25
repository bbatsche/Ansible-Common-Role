require 'logger'
require 'singleton'

class VagrantHelper
  include Singleton

  CMD_VERBS = {
    :up        => "Booting",
    :provision => "Provisioning",
    :destroy   => "Destroying"
  }

  MACHINES = {
    :trusty => "spec-trusty",
    :xenial => "spec-xenial"
  }

  def initialize
    @logFilename = "vagrant.log"
    @logger = Logger.new @logFilename

    @logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.strftime "%H:%M:%S"

      "[#{date_format}] #{msg}\n"
    end
  end

  def cmd(cmd, flags=[], machine=nil)
    if !CMD_VERBS.has_key? cmd
      raise "    Cannot execute vagrant command \"#{cmd.to_s}\"!"
    end

    vms = MACHINES.values

    if !machine.nil?
      if !MACHINES.has_key? machine
        raise "    #{machine.to_s} is not a known vagrant VM."
      end

      vms = MACHINES.values_at machine
    end

    flags = flags.join " "

    vms.each do |vm|
      puts "==> #{CMD_VERBS[cmd]} #{vm} test environment (this may take several minutes)"
      IO.popen("vagrant #{cmd.to_s} #{flags} #{vm}") do |io|
        io.each do |line|
          @logger.info line.strip
        end
      end

      if !$?.success?
        raise "    #{CMD_VERBS[cmd]} VM #{vm} failed! See #{@logFilename} for more details."
      end
    end
  end
end
