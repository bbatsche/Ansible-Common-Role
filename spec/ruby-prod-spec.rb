require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook('playbooks/ruby.yml', { env_name: "production" })
  end
end

describe command("sudo gem install sass") do
  its(:stdout) { should match /1 gem installed/ }

  its(:stdout) { should_not match /Installing ri documentation/ }
  its(:stdout) { should_not match /Installing RDoc documentation/ }

  its(:exit_status) { should eq 0 }
end
