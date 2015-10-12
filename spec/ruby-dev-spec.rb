require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision('playbooks/ruby.yml', { app_env: "dev" })
  end
end

describe command("sudo gem install sass") do
  its(:stdout) { should match /1 gem installed/ }

  its(:stdout) { should match /Installing ri documentation/ }
  its(:stdout) { should match /Installing RDoc documentation/ }

  its(:exit_status) { should eq 0 }
end
