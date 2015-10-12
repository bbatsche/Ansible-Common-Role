require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision 'playbooks/swap.yml'
  end
end

describe command("swapon -s") do
  its(:stdout) { should match /^.+\s+(file|partition)\s+\d+/ }
end

describe file("/etc/fstab") do
  its(:content) { should match /^.+\s+none\s+swap\s+(sw(ap)?|(defaults)).*\s+0\s+0\s*$/ }
end
