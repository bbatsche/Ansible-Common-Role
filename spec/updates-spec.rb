require_relative "lib/bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook "playbooks/updates.yml"
  end
end

describe "Aptitude" do
  let(:aptitude_version) {
    {
        "14.04" => "0.6.",
        "16.04" => "0.7.",
        "18.04" => "0.8."
    }[os[:release]]
  }
  let(:subject) { command "aptitude --version" }

  it "should be installed" do
    expect(subject.stdout).to match /^aptitude #{Regexp.quote(aptitude_version)}\d/
  end

  include_examples "no errors"
end

describe "Landscape", :sudo => true do
  let(:subject) { command "landscape-sysinfo" }

  it "should not include a link to canonical" do
    expect(subject.stdout).not_to match /Graph this data and manage this system at/
    expect(subject.stdout).not_to match /landscape.canonical.com/
  end

  include_examples "no errors"
end
