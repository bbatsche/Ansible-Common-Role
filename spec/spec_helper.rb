require 'serverspec'
require 'net/ssh'
require 'tempfile'
require 'singleton'

# make a singleton
class SpecHelper
  include Singleton

  def initialize(host = ENV['HOST_NAME'])
    @hostname = host

    @sshConfig = Tempfile.new('ssh', Dir.tmpdir)
    @sshConfig.write(`vagrant ssh-config #{@hostname}`)
    @sshConfig.close

    @inventory = Tempfile.new('inventory', Dir.tmpdir)
    @inventory.write("#{@hostname} ansible_ssh_host=#{sshOptions[:host_name]} ansible_ssh_port=#{sshOptions[:port]} ansible_ssh_private_key_file=#{sshOptions[:keys][0]}")
    @inventory.close
  end

  def sshOptions
    Net::SSH::Config.for(@hostname, [@sshConfig.path])
  end

  def provision(playbook, extraVars = {})
    playbook = File.expand_path(playbook, File.dirname(__FILE__))

    cmd = "ansible-playbook -i #{@inventory.path} #{playbook}"

    extraVars.each do |key, value|
      cmd << " -e \"#{key.to_s}=#{value}\""
    end

    system cmd
  end
end

options = SpecHelper.instance.sshOptions

set :backend, :ssh

set :host,        options[:host_name]
set :ssh_options, options

# Disable sudo
set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
# set :path, '/sbin:/usr/local/sbin:$PATH'
