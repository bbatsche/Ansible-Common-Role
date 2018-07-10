require_relative "ansible_helper"
require_relative "docker_env"
require_relative "vagrant_env"

if ENV["CONTINUOUS_INTEGRATION"] == "true"
  # CI server will use docker for environments
  [
    {:name => "trusty", :image => Docker::Image.create("fromImage" => "ubuntu:trusty")},
    {:name => "xenial", :image => Docker::Image.create("fromImage" => "ubuntu:xenial")},
    {:name => "bionic", :image => Docker::Image.build("from ubuntu:bionic\nrun apt-get update && apt-get install -y init")}
  ].each do |vm|
    env = DockerEnv.new(vm[:name], vm[:image])
    env.use_python3 = ENV["ANSIBLE_PYTHON_VERSION"] == "3"
    AnsibleHelper << env
  end
else
  ["trusty", "xenial", "bionic"].each do |vm|
    env = VagrantEnv.new(vm)
    env.use_python3 = ENV["ANSIBLE_PYTHON_VERSION"] == "3"
    AnsibleHelper << env
  end
end
