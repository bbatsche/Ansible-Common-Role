require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/timezone.yml'
  end
end

describe command("date '+%Z'") do
  its(:stdout) { should match /UTC/ }
end
