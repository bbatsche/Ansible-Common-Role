require_relative "lib/ansible_helper"
require_relative "bootstrap"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/swap.yml", ENV["TARGET_HOST"], { swap_mb: 1024, swap_path: "/swap" })
  end

  config.before :all do
    skip "Cannot reliably manage swap memory in Docker" if AnsibleHelper[ENV["TARGET_HOST"]].is_a? DockerEnv
  end
end

describe command("swapon -s") do
  it "has the swap file enabled" do
    expect(subject.stdout).to match /^\/swap\s+(file|partition)\s+\d+/
  end
end

describe file("/etc/fstab") do
  it "has the swap file included" do
    expect(subject.content).to match /^\/swap\s+none\s+swap\s+(sw(ap)?|(defaults))/
  end
end
