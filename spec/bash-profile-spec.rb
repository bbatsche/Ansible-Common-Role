require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook 'playbooks/bash-profile-default.yml'
  end
end

describe file('/etc/profile.d/bash_completion.sh') do
  it { should exist }
  it { should be_file }
end

# Can't think of a good way to test color prompt; the following doesn't work =(
# describe command("bash -ilc 'echo $PS1'") do
#   its(:stdout) { should include "\\[\\033[01;32m\\]\\u@\\h\\[\\033[00m\\]" }
# end

describe command("bash -ic 'll ~'") do
  its(:stdout) { should match /^-rw-r--r--\s+\d+\s+\w+\s+\w+\s+1.0K\s+\w+\s+\d+\s+\d+(:\d+)?\s+test$/ }
  its(:stdout) { should match /^drwxr-xr-x\s+\d+\s+\w+\s+\w+\s+[0-9.]+(K|M|G)?\s+\w+\s+\d+\s+\d+(:\d+)?\s+test_dir\/$/ }

  its(:stderr) { should_not match /ll: command not found/ }
  its(:exit_status) { should eq 0 }
end

describe command("bash -ic 'la ~'") do
  its(:stdout) { should match /^-rw-r--r--\s+\d+\s+\w+\s+\w+\s+1.0K\s+\w+\s+\d+\s+\d+(:\d+)?\s+test$/ }
  its(:stdout) { should match /^-rwxr-xr-x\s+\d+\s+\w+\s+\w+\s+1.0M\s+\w+\s+\d+\s+\d+(:\d+)?\s+.test\*$/ }
  its(:stdout) { should match /^drwxr-xr-x\s+\d+\s+\w+\s+\w+\s+[0-9.]+(K|M|G)?\s+\w+\s+\d+\s+\d+(:\d+)?\s+test_dir\/$/ }

  its(:stdout) { should_not match /\s+\.\/?$/ }
  its(:stdout) { should_not match /\s+\.\.\/?$/ }

  its(:stderr) { should_not match /la: command not found/ }
  its(:exit_status) { should eq 0 }
end
