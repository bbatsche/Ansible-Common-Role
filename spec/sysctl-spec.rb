require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/sysctl.yml", ENV["TARGET_HOST"], {shmmax_percent: 25, shmall_percent: 25})
  end
end

describe linux_kernel_parameter("kernel.pid_max") do
  it "should be increased" do
    expect(subject.value).to be > 32768
  end
end

describe linux_kernel_parameter("fs.file-max") do
  # convert to MB
  totalMem = host_inventory["memory"]["total"].to_i / 1024

  it "should be 256 for every 4MB of RAM" do
    expect(subject.value).to be_within(200).of((totalMem / 4) * 256)
  end
end

describe linux_kernel_parameter("kernel.shmmax") do
  # convert to bytes
  totalMem = host_inventory["memory"]["total"].to_i * 1024

  it "should be 1/4 of total RAM" do
    # within 1% of total mem
    expect(subject.value).to be_within(0.01 * totalMem).of(totalMem / 4)
  end
end

describe linux_kernel_parameter("kernel.shmall") do
  # convert to pages
  totalMem = host_inventory["memory"]["total"].to_i * 1024 / 4096

  it "should be 1/4 of total RAM" do
    # within 1% of total mem
    expect(subject.value).to be_within(0.01 * totalMem).of(totalMem / 4)
  end
end
