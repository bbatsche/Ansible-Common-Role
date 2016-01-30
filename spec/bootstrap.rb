require 'serverspec'

options = SpecHelper.instance.sshOptions

set :backend, :ssh

set :host,        options[:host_name]
set :ssh_options, options

# Disable sudo
set :disable_sudo, true

# Set environment variables
# set :env, :LANG => 'C', :LC_MESSAGES => 'C'

# Set PATH
set :path, '/sbin:/usr/local/sbin:/usr/local/bin:$PATH'
