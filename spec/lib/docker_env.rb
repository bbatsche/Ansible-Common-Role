require "docker"
require "tempfile"

class DockerEnv
  attr_reader :name, :image

  def initialize(name, image)
    @name  = name
    @image = image
  end

  def up
    container.start
  end

  def provision
    inventory = Tempfile.new("inventory")

    inventory << inventory_line

    inventory.close

    command = "ansible-playbook", "-i", inventory.path, "-l", @name, "provision-playbook.yml"

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
      || @container = Docker::Container.create("Cmd" => ["/sbin/init"], "Image" => image.id, "name" => name)
  end

  def id
    container.id
  end

  def inventory_line
    "#{@name} ansible_connection=docker ansible_user=root"
  end
end
