require 'net/ssh'
require 'tempfile'
require 'singleton'
require 'shellwords'
require_relative 'vagrant_helper'

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
    @sshConfig.write `vagrant ssh-config`
    @sshConfig.close

    invContent = "";

    VagrantHelper::MACHINES.each_value do |vm|
      opts = sshOptions vm
      keyPath = Shellwords.escape opts[:keys].first

      invContent << "#{vm} ansible_ssh_host=#{opts[:host_name]} ansible_ssh_user=#{opts[:user]} "
      invContent << "ansible_ssh_port=#{opts[:port]} ansible_ssh_private_key_file=#{keyPath}\n"
    end

    @inventory = Tempfile.new('inventory', Dir.tmpdir)
    @inventory.write invContent
    @inventory.close
  end

  def sshOptions host = nil
    host = resolveHost host
    raise ArgumentError.new('Missing argument "host"') if host.nil?

    Net::SSH::Config.for(host, [@sshConfig.path])
  end

  def playbook(playbookFile, host = nil, extraVars = {})
    specDir      = File.expand_path(File.dirname(__FILE__) + "/../")
    playbookFile = Shellwords.escape(File.expand_path(playbookFile, specDir))
    host         = resolveHost host

    raise ArgumentError.new('Missing argument "host"') if host.nil?

    cmd = "ansible-playbook -i #{@inventory.path}"
    cmd << " -l #{host}" unless host.nil?
    cmd << " #{playbookFile}"

    extraVars.each do |key, value|
      cmd << " -e \"#{key.to_s}=#{value}\""
    end

    system cmd
  end

  def cmd(moduleName, host = nil, moduleArgs = "")
    host = resolveHost host
    host = "all" if host.nil?

    cmd = "ansible #{host} -i #{@inventory.path} -m #{moduleName} --become"

    if moduleArgs != ""
      moduleArgs = Shellwords.escape moduleArgs

      cmd << " -a #{moduleArgs}"
    end

    system cmd
  end

  def resolveHost host = nil
    return host unless host.nil?
    return ENV["TARGET_HOST"] if ENV.has_key? "TARGET_HOST"
  end
end
