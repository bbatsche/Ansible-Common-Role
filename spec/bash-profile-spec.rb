require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/bash-profile-default.yml"
  end
end

describe file('/etc/profile.d/bash_completion.sh') do
  it { should exist }
  it { should be_file }
end

describe "ll alias" do
  set :interactive_shell, true
  let(:subject) { command "ll /tmp/mocks" }

  include_examples "bash aliases"
  include_examples "bash regular files"

  it "should have no errors" do
    expect(subject.stderr).to_not match /ll: command not found/
    expect(subject.exit_status).to eq 0
  end
end

describe "la alias" do
  set :interactive_shell, true
  let(:subject) { command "la /tmp/mocks" }

  include_examples "bash aliases"
  include_examples "bash hidden files"

  it "should have no errors" do
    expect(subject.stderr).to_not match /la: command not found/
    expect(subject.exit_status).to eq 0
  end
end
