require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/nodejs"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/nodejs.yml"
  end
end

describe "node" do
  include_examples("nodejs", "node")
end

describe "nodejs" do
  include_examples("nodejs", "nodejs")
end

describe command("npm --version") do
  it "should be a correct version" do
    expect(subject.stdout).to match /^\d+\.\d+\.\d+$/
  end

  include_examples "no errors"
end
