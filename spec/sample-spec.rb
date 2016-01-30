require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/sample-playbook.yml"
  end
end

describe command("echo hello") do
  its(:stdout) { should match /hello/ }

  its(:exit_status) { should eq 0 }
end
