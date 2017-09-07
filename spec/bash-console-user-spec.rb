require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/bash"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/bash-profile-user.yml"
  end
end

describe command(%Q{su -l test_user -c 'bash -ic "ll /tmp/mocks"'}) do
  let(:disable_sudo) { false }

  include_examples "bash::aliases"
  include_examples "bash::regular_files"

  it "should not cause any errors" do
    expect(subject.stderr).to_not match /ll: command not found/
    expect(subject.exit_status).to eq 0
  end
end

describe command(%Q{su -l test_user -c 'bash -ic "la /tmp/mocks"'}) do
  let(:disable_sudo) { false }

  include_examples "bash::aliases"
  include_examples "bash::hidden_files"

  it "should not cause any errors" do
    expect(subject.stderr).to_not match /la: command not found/
    expect(subject.exit_status).to eq 0
  end
end
