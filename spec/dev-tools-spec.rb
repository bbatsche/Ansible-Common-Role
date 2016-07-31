require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/dev-tools.yml'
  end
end

describe command("git --version") do
  it "has git installed" do
    expect(subject.stdout).to match /git version \d+\.\d+\.\d+/
    expect(subject.exit_status).to eq 0
  end
end

describe command("echo 'stats\r\n' | nc localhost 11300") do
  it "has beanstalk installed and running" do
    expect(subject.stdout).to match /^OK \d+/
  end
end

describe command("supervisorctl version") do
  let(:disable_sudo) { false }

  it "has supervisor installed" do
    expect(subject.stdout).to match /^3\.\d.*/
    expect(subject.exit_status).to eq 0
  end
end

describe command("bower --version") do
  it "has bower installed" do
    expect(subject.stdout).to match /\d+\.\d+\.\d+/
    expect(subject.exit_status).to eq 0
  end
end

describe command("gulp --version") do
  it "has gulp installed" do
    expect(subject.stdout).to match /CLI version \d+\.\d+\.\d+/
    expect(subject.exit_status).to eq 0
  end
end

describe command("grunt --version") do
  it "has grunt installed" do
    expect(subject.stdout).to match /grunt-cli v\d+\.\d+\.\d+/
    expect(subject.exit_status).to eq 0
  end
end

describe command("sass --version") do
  it "has sass installed" do
    expect(subject.stdout).to match /Sass \d+\.\d+\.\d+/
    expect(subject.exit_status).to eq 0
  end
end
