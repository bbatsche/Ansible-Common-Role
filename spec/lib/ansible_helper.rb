require 'net/ssh'
require 'tempfile'
require 'singleton'
require 'shellwords'

class AnsibleHelper
  include Singleton

  def initialize
    if ENV.has_key?("CONTINUOUS_INTEGRATION") && ENV["CONTINUOUS_INTEGRATION"] == "true"
      @inventory = File.new 'inventory'
      @inventory.close # don't need to hold on the handle, just need a pointer for the file's path
    else
      generateInventory
    end
  end

  def generateInventory
    @sshConfig = Tempfile.new('ssh', Dir.tmpdir)
    @sshConfig.write(`vagrant ssh-config default`)
    @sshConfig.close

    @inventory = Tempfile.new('inventory', Dir.tmpdir)

    keyPath = Shellwords.escape(sshOptions[:keys].first)

    invContent = "default ansible_ssh_host=#{sshOptions[:host_name]} ansible_ssh_user=#{sshOptions[:user]} "
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
    cmd = "ansible default -i #{@inventory.path} -m #{moduleName} --become"

    if moduleArgs != ""
      moduleArgs = Shellwords.escape moduleArgs

      cmd << " -a #{moduleArgs}"
    end

    system cmd
  end
end
