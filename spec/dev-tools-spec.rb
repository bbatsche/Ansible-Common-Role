require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/dev-tools.yml"
  end
end

describe command("git --version") do
  it "git is installed" do
    expect(subject.stdout).to match /git version \d+\.\d+\.\d+/
  end
  include_examples "no errors"
end

describe command('echo -e "stats\\r" | nc localhost 11300') do
  it "beanstalkd is running" do
    expect(subject.stdout).to match /^OK \d+/
  end
  include_examples "no errors"
end

describe command("supervisorctl version") do
  let(:disable_sudo) { false }

  it "supervisor is installed" do
    expect(subject.stdout).to match /^\d+\.\d+/
  end
  include_examples "no errors"
end

describe command("bower --version") do
  it "bower is isntalled" do
    expect(subject.stdout).to match /^\d+\.\d+\.\d+$/
  end
  include_examples "no errors"
end

describe command("gulp --version") do
  it "gulp is installed" do
    expect(subject.stdout).to match /CLI version \d+\.\d+\.\d+$/
  end
  include_examples "no errors"
end

describe command("grunt --version") do
  it "grunt is installed" do
    expect(subject.stdout).to match /^grunt-cli v\d+\.\d+\.\d+$/
  end
  include_examples "no errors"
end

describe command("yarn --version") do
  it "yarn is installed" do
    expect(subject.stdout).to match /^\d+\.\d+\.\d+$/
  end
  include_examples "no errors"
end

describe command("sass --version") do
  it "sass is installed" do
    expect(subject.stdout).to match /^Sass \d+\.\d+\.\d+/
  end
  include_examples "no errors"
end
