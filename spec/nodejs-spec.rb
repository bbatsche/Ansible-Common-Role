require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/nodejs.yml'
  end
end

describe command("node -e \"console.log('node installed');\"") do
  its(:stdout) { should eq "node installed\n" }
  its(:exit_status) { should eq 0 }
end

describe command("nodejs -e \"console.log('node installed');\"") do
  its(:stdout) { should eq "node installed\n" }
  its(:exit_status) { should eq 0 }
end

describe command("npm version") do
  its(:exit_status) { should eq 0 }
end
