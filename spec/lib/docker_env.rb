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

    `ansible-playbook -i #{inventory.path} -l #{@name} provision-playbook.yml --skip-tags="timezone,sysctl,ruby,node"`
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
      || @container = Docker::Container.create('Cmd' => ['sleep', 'infinity'], 'Image' => image, 'name' => name, 'Privileged' => true)
  end

  def id
    container.id
  end

  def inventory_line
    "#{@name} ansible_connection=docker ansible_user=root"
  end
end
