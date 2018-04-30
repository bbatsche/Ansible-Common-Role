require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/updates.yml"
  end
end


describe command("aptitude --version") do
  aptititudeVersions = {
    "14.04" => "0.6.",
    "16.04" => "0.7.",
    "18.04" => "0.8."
  }

  version = aptititudeVersions[os[:release]]

  it "should have aptitude installed" do
    expect(subject.stdout).to match /^aptitude #{Regexp.quote(version)}\d/
  end

  include_examples "no errors"
end

describe command("landscape-sysinfo") do
  let(:disable_sudo) { false } # landscape client config is not readable by normal users

  it "should not include a link to canonical" do
    expect(subject.stdout).not_to match /Graph this data and manage this system at/
    expect(subject.stdout).not_to match /landscape.canonical.com/
  end

  include_examples "no errors"
end
