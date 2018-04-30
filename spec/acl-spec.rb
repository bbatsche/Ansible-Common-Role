require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/acl.yml"
  end
end

describe group("web-admin") do
  it { should exist }
end

describe group("www-data") do
  it { should exist }
end

describe user(command("whoami").stdout.strip) do
  it { should belong_to_group "web-admin" }
  it { should belong_to_group "www-data" }
end

describe command("setfacl -m g:web-admin:rwx,d:g:web-admin:rwx $HOME/acl_test") do
  let(:disable_sudo) { false }

  describe "setting file ACL" do
    include_examples "no errors"
  end
end

describe command("touch $HOME/acl_test/test") do
  after :all do
    set :disable_sudo, false
    raise "Cleanup Failed" if command("rm -rf $HOME/acl_test").exit_status != 0
    set :disable_sudo, true
  end

  describe "using file ACLs" do
    include_examples "no errors"
  end
end
