require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/bash"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/bash-profile-default.yml"
  end
end

describe file('/etc/profile.d/bash_completion.sh') do
  it { should exist }
  it { should be_file }
end

describe command("ll /tmp/mocks") do
  let(:interactive_shell) { true }

  include_examples "bash::aliases"
  include_examples "bash::regular_files"

  it "should not cause any errors" do
    expect(subject.stderr).to_not match /ll: command not found/
    expect(subject.exit_status).to eq 0
  end
end

describe command("la /tmp/mocks") do
  let(:interactive_shell) { true }

  include_examples "bash::aliases"
  include_examples "bash::hidden_files"

  it "should not cause any errors" do
    expect(subject.stderr).to_not match /la: command not found/
    expect(subject.exit_status).to eq 0
  end
end
