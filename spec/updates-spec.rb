require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/updates.yml'
  end
end

describe command("sudo unattended-upgrade --dry-run --verbose") do
  its(:stdout) { should match /^Allowed origins are: \['o=Ubuntu,a=trusty-security'\]$/ }
  its(:exit_status) { should eq 0 }
end
