require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/timezone"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.playbook("playbooks/timezone.yml", ENV["TARGET_HOST"], { timezone: "America/Phoenix" })
  end
end

describe "Timezone" do
  include_examples("timezone", "America/Phoenix")
end
