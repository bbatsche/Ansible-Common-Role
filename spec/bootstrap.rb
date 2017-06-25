require "serverspec"
require_relative "lib/ansible_helper"

if ENV.has_key?("CONTINUOUS_INTEGRATION") && ENV["CONTINUOUS_INTEGRATION"] == "true"
  set :backend, :exec
else
  options = AnsibleHelper.instance.sshOptions ENV['TARGET_HOST']

  set :backend, :ssh

  set :ssh_options, options
end


# Disable sudo
set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
set :path, '/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:$PATH'
