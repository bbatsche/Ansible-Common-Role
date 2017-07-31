require_relative "lib/ansible_helper"
require_relative "bootstrap"
require_relative "shared/timezone"

RSpec.configure do |config|
  config.before :suite do
    AnsibleHelper.instance.playbook "playbooks/timezone.yml"
  end
end

describe "Timezone" do
  include_examples("timezone", "Etc/UTC")
end
