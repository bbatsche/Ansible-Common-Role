require "serverspec"
require_relative "lib/ansible_helper"
require_relative "environments"
require_relative "shared/no_errors"

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
