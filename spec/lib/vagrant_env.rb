require 'net/ssh'
require 'shellwords'
require 'tempfile'

class VagrantEnv
  attr_reader :name

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

    "#{@name} ansible_host=#{config[:host_name]} ansible_user=#{config[:user]} ansible_port=#{config[:port]} ansible_ssh_private_key_file=#{keyPath}"
  end

  def sshConfig
    configFile = Tempfile.new "ssh"

    configFile.write exec("ssh-config").join("\n")
    configFile.close

    Net::SSH::Config.for(@name, [configFile.path])
  ensure
    configFile.unlink unless configFile.nil?
  end

  def exec(command, flags=[])
    command = ["vagrant", command, @name] + flags

    output = []
    IO.popen(command, {:err => [:child, :out]}) do |io|
      io.each do |line|
        output << line.strip
      end
    end

    if !$?.success?
      raise ExecError.new("Vagrant execution error!", output)
    end

    return output
  end
end
