require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/acl.yml'
  end
end

describe group("web-admin") do
  it { should exist }
end

describe user("vagrant") do
  it { should belong_to_group "web-admin" }
end

describe command("setfacl -m g:web-admin:rwx,d:g:web-admin:rwx ~/acl_test") do
  let(:disable_sudo) { false }
  it "has ACLs enabled" do
    expect(subject.stderr).to eq ""
    expect(subject.exit_status).to eq 0
  end
end

describe command("touch ~/acl_test/test") do
  after :all do
    set :disable_sudo, false
    raise "Cleanup Failed" if command("rm -rf /home/vagrant/acl_test").exit_status != 0
    set :disable_sudo, true
  end

  it "allows the current user to write to the directory" do
    expect(subject.stderr).to eq ""
    expect(subject.exit_status).to eq 0
  end
end
