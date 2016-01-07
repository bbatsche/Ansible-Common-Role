require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision 'playbooks/sample-playbook.yml'
  end
end

describe command("echo hello") do
  its(:stdout) { should match /hello/ }

  its(:exit_status) { should eq 0 }
end
