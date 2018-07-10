require 'net/ssh'
require 'shellwords'
require 'tempfile'
require_relative "exec_error"

class VagrantEnv
  attr_reader :name
  attr_accessor :use_python3

  def initialize(name)
    @name = name
  end

  def up
    exec("up", ["--provider=virtualbox", "--no-color", "--no-provision"])
  end

  def provision
    exec "provision"
  end

  def down
    exec "halt"
  end

  def destroy
    exec("destroy", ["--force"])
  end

  def inventory_line
    config  = sshConfig
    keyPath = Shellwords.escape config[:keys].first

    line = "#{name} ansible_host=#{config[:host_name]} ansible_user=#{config[:user]}"
    line << " ansible_port=#{config[:port]} ansible_ssh_private_key_file=#{keyPath}"
    line << " ansible_python_interpreter=/usr/bin/python3" if use_python3

    return line
  end

  def sshConfig
    configFile = Tempfile.new "ssh"

    configFile.write exec("ssh-config").join("\n")
    configFile.close

    Net::SSH::Config.for(name, [configFile.path])
  ensure
    configFile.unlink unless configFile.nil?
  end

  def exec(command, flags=[])
    command = ["vagrant", command, name] + flags

    output = []
    IO.popen(command, {:err => [:child, :out]}) do |io|
      output = io.readlines.collect(&:strip)
    end

    unless $?.success?
      raise ExecError.new("Vagrant exec error!", output)
    end

    return output
  end
end
