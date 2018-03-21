require_relative "ansible_helper"
require_relative "docker_env"
require_relative "vagrant_env"

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
