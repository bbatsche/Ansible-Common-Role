require "docker"
require "tempfile"
require "yaml"
require "deep_merge"
require "json"

class DockerEnv
  attr_reader :name, :image
  attr_accessor :use_python3

  def initialize(name, image)
    @name  = name
    @image = image
  end

  def up
    container.start
  end

  def provision
    default_config_file = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), "config.yml.dist")
    local_config_file   = File.join(File.dirname(File.dirname(File.dirname(__FILE__))), "config.yml")

    config_data = YAML.load_file default_config_file
    config_data.deep_merge!(YAML.load_file local_config_file) if File.exists? local_config_file

    inventory = Tempfile.new("inventory")

    inventory << inventory_line

    inventory.close

    command = "ansible-playbook", "-i", inventory.path, "-l", name, "provision-playbook.yml", "-e", config_data["ansible"]["vars"].to_json

    output = []
    IO.popen(command, {:err => [:child, :out]}) do |io|
      output = io.readlines.collect(&:strip)
    end

    unless $?.success?
      raise ExecError.new("Ansible provision error!", output)
    end
  ensure
    inventory.unlink unless inventory.nil?
  end

  def down
    container.stop
  end

  def destroy
    container.remove
  end

  def container
    @container \
      || @container = Docker::Container.all(all: true, filters: { name: [name] }.to_json).first \
      || @container = Docker::Container.create({
        "Cmd" => ["/sbin/init"],
        "Image" => image.id,
        "name" => name,
        "Privileged" => true,
      })
  end

  def id
    container.id
  end

  def inventory_line
    "#{name} ansible_connection=docker ansible_user=root" + (use_python3 ? " ansible_python_interpreter=/usr/bin/python3" : "")
  end
end
