require "serverspec"
require_relative "lib/ansible_helper"
require_relative "shared/no_errors"

if ENV.has_key?("CONTINUOUS_INTEGRATION") && ENV["CONTINUOUS_INTEGRATION"] == "true"
  set :backend, :exec
else
  set :backend, :ssh

  set :ssh_options, AnsibleHelper.instance.sshOptions
end


# Disable sudo
set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
set :path, '/sbin:/usr/sbin:/usr/local/sbin:/usr/local/bin:$PATH'
