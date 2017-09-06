require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/sample-playbook.yml"
  end
end

describe command("echo hello") do
  its(:stdout) { should match /hello/ }

  include_examples "no errors"
end

describe command("lsb_release -a") do
  it "is Ubuntu" do
    expect(subject.stdout).to match /^Distributor ID:\s+Ubuntu$/
  end

  it "is an LTS release" do
    expect(subject.stdout).to match /^Description:\s+.+LTS$/
  end

  include_examples "no errors"

  if os[:release] == "14.04"
    it "is Trusty Tahr" do
      expect(subject.stdout).to match /^Release:\s+14.04$/
      expect(subject.stdout).to match /^Codename:\s+trusty$/
    end
  end

  if os[:release] == "16.04"
    it "is Xenial Xerus" do
      expect(subject.stdout).to match /^Release:\s+16.04$/
      expect(subject.stdout).to match /^Codename:\s+xenial$/
    end
  end
end
