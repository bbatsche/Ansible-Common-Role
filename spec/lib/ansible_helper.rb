require 'net/ssh'
require 'tempfile'
require 'singleton'
require 'shellwords'

class AnsibleHelper
  include Singleton

  def initialize
    @sshConfig = Tempfile.new('ssh', Dir.tmpdir)
    @sshConfig.write(`vagrant ssh-config default`)
    @sshConfig.close

    @inventory = Tempfile.new('inventory', Dir.tmpdir)

    keyPath = Shellwords.escape(sshOptions[:keys].first)

    invContent = "default ansible_ssh_host=#{sshOptions[:host_name]} "
    invContent << "ansible_ssh_port=#{sshOptions[:port]} ansible_ssh_private_key_file=#{keyPath}"

    @inventory.write(invContent)
    @inventory.close
  end

  def sshOptions
    Net::SSH::Config.for("default", [@sshConfig.path])
  end

  def playbook(playbookFile, extraVars = {})
    specDir = File.expand_path(File.dirname(__FILE__) + "/../")
    playbookFile = Shellwords.escape(File.expand_path(playbookFile, specDir))

    cmd = "ansible-playbook -i #{@inventory.path} #{playbookFile}"

    extraVars.each do |key, value|
      cmd << " -e \"#{key.to_s}=#{value}\""
    end

    system cmd
  end

  def cmd(moduleName, moduleArgs = "")
    cmd = "ansible default -i #{@inventory.path} -m #{moduleName} -u vagrant --become"

    if moduleArgs != ""
      moduleArgs = Shellwords.escape moduleArgs

      cmd << " -a #{moduleArgs}"
    end

    system cmd
  end
end
