require "serverspec"
require_relative "environments"

Dir[File.join(File.dirname(File.dirname(__FILE__)), "shared", "*.rb")].each { |file| require_relative file }

if ENV["CONTINUOUS_INTEGRATION"] == "true"
  set :backend, :docker

  set :docker_container, AnsibleHelper[ENV["TARGET_HOST"]].id

  # Trigger OS info refresh
  Specinfra.backend.os_info
else
  set :backend, :ssh

  set :ssh_options, AnsibleHelper[ENV["TARGET_HOST"]].sshConfig
end

# Disable sudo
set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
set :path, "/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin:$PATH"

set :shell, "/bin/bash"

RSpec.configure do |config|
  config.around :each, sudo: true do |example|
    set :disable_sudo, false
    example.run
    set :disable_sudo, true
  end
end
