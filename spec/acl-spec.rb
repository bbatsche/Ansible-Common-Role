require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/acl.yml"

    Specinfra::Runner.set_config :ssh, nil # kill existing SSH connection
  end
end

describe group "web-admin" do
  it { should exist }
end

describe group "www-data" do
  it { should exist }
end

describe group "adm" do
  it { should exist }
end

describe user command("whoami").stdout.strip do
  it { should belong_to_group "web-admin" }
  it { should belong_to_group "www-data" }
  it { should belong_to_group "adm" }
end

context "File ACLs" do
  after :all do
    set :disable_sudo, false
    raise "Cleanup Failed" if command("rm -rf $HOME/acl_test").exit_status != 0
  end


  describe "Setting ACL", :sudo => true do
    let(:subject) { command "setfacl -m g:web-admin:rwx,d:g:web-admin:rwx $HOME/acl_test" }

    include_examples "no errors"
  end

  describe "Writing data using ACL" do
    let(:subject) { command "touch $HOME/acl_test/test" }

    include_examples "no errors"
  end
end
