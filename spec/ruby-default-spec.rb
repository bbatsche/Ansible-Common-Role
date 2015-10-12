require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision 'playbooks/ruby.yml'
  end
end

describe command("ruby -e \"puts 'ruby installed'\"") do
  its(:stdout) { should eq "ruby installed\n" }
  its(:exit_status) { should eq 0 }
end

describe command("ruby2.0 -e \"puts 'ruby installed'\"") do
  its(:stdout) { should eq "ruby installed\n" }
  its(:exit_status) { should eq 0 }
end

describe command("ruby1.9.1 --version") do
  its(:stdout) { should match /\b1\.9\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("ruby2.0 --version") do
  its(:stdout) { should match /\b2\.0\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("gem --version") do
  its(:exit_status) { should eq 0 }
end

describe command("gem1.9.1 --version") do
  its(:stdout) { should match /\b1\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("gem2.0 --version") do
  its(:stdout) { should match /\b2\.\d+\.\d+/ }
  its(:exit_status) { should eq 0 }
end

describe command("sudo gem install sass") do
  its(:stdout) { should match /1 gem installed/ }

  its(:stdout) { should match /Installing ri documentation/ }
  its(:stdout) { should match /Installing RDoc documentation/ }

  its(:exit_status) { should eq 0 }
end
