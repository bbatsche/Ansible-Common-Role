require 'logger'
require 'singleton'

class VagrantHelper
  include Singleton

  def initialize
    @logFilename = "vagrant.log"
    @logger = Logger.new @logFilename

    @logger.formatter = proc do |severity, datetime, progname, msg|
      date_format = datetime.strftime "%H:%M:%S"

      "[#{date_format}] #{msg}\n"
    end
  end

  def cmd(name, cmd)
    puts "==> #{name} test environment (this may take several minutes)"
    IO.popen("vagrant #{cmd} default") do |io|
      io.each do |line|
        @logger.info line.strip
      end
    end

    if !$?.success?
      raise "    #{name} test environment failed! See #{@logFilename} for more details."
    end
  end
end
