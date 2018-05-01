require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/bash-profile-user.yml"
  end
end

describe command %Q{su -l test_user -c 'bash -ic "ll /tmp/mocks"'} do
  let(:disable_sudo) { false }

  include_examples "bash aliases"
  include_examples "bash regular files"

  it "should have no errors" do
    expect(subject.stderr).to_not match /ll: command not found/
    expect(subject.exit_status).to eq 0
  end
end

describe command %Q{su -l test_user -c 'bash -ic "la /tmp/mocks"'} do
  let(:disable_sudo) { false }

  include_examples "bash aliases"
  include_examples "bash hidden files"

  it "should have no errors" do
    expect(subject.stderr).to_not match /la: command not found/
    expect(subject.exit_status).to eq 0
  end
end
