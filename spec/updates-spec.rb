require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/updates.yml"
  end
end

describe command("aptitude --version") do
  pattern = if os[:release] == "14.04" then /^aptitude 0\.6\.\d/ else /^aptitude 0\.7\.\d/ end

  it "should have aptitude installed" do
    expect(subject.stdout).to match pattern
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

describe command("unattended-upgrade --dry-run --verbose") do
  let(:disable_sudo) { false }

  codename = if os[:release] == "14.04" then "trusty" else "xenial" end

  it "should have just security and ESM origins" do
    expect(subject.stdout).to match /^Allowed origins are: \['o=Ubuntu,a=#{Regexp.quote(codename)}-security', 'o=UbuntuESM,a=#{Regexp.quote(codename)}'\]$/
  end

  include_examples "no errors"
end
