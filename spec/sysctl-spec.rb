require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision 'playbooks/sysctl.yml'
  end
end

# Assert that we have upped the number of PID's, and thus our config was loaded successfully.
describe linux_kernel_parameter("kernel.pid_max") do
  its(:value) { should be > 32768 }
end
