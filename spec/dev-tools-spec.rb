require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision 'playbooks/dev-tools.yml'
  end
end

describe command("git --version") do
  its(:stdout) { should match /git version \d+\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("bower --version") do
  its(:stdout) { should match /\d+\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("gulp --version") do
  its(:stdout) { should match /CLI version \d+\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("grunt --version") do
  its(:stdout) { should match /grunt-cli v\d+\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("sass --version") do
  its(:stdout) { should match /Sass \d+\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end
