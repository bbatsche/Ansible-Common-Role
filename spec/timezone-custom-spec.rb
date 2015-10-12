require_relative 'spec_helper'

RSpec.configure do |config|
  config.before :suite do
    SpecHelper.instance.provision('playbooks/timezone.yml', { timezone: "America/Phoenix" })
  end
end

describe command("date '+%Z'") do
  its(:stdout) { should match /MST/ }
end
