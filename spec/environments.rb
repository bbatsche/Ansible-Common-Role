require_relative "lib/ansible_helper"
require_relative "lib/docker_env"
require_relative "lib/vagrant_env"

if ENV["CONTINUOUS_INTEGRATION"] == "true"
  # CI server will use docker for environments
  [
    {:name => "trusty", :image => "ubuntu:trusty"},
    {:name => "xenial", :image => "ubuntu:xenial"}
  ].each do |vm|
    AnsibleHelper << DockerEnv.new(vm[:name], vm[:image])
  end
else
  ["trusty", "xenial"].each do |vm|
    AnsibleHelper << VagrantEnv.new(vm)
  end
end
