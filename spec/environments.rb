Dir[File.join(File.dirname(__FILE__), "lib", "*.rb")].each { |file| require_relative file }

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
