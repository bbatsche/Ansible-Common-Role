require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/sysctl.yml'
  end
end

# Assert that we have upped the number of PID's, and thus our config was loaded successfully.
describe linux_kernel_parameter("kernel.pid_max") do
  its(:value) { should be > 32768 }
end
