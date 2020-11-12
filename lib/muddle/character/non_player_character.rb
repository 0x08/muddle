require_relative "character"

class NonPlayerCharacter < Character
  attr_reader :name, :description, :hitpoints, :id

  def initialize(id, name, description, hitpoints, location, configuration)
    @id = id
    @name = name
    @description = description
    @hitpoints = hitpoints
    @location = location
    @logger = Logger.new(STDOUT)
    @configuration = configuration
  end

  def to_s
    @name
  end

  def run
    @logger.info("starting #{name} npc thread")
    t = Thread.new do
      while true
        Kernel.sleep(Kernel.rand(10))
        roam
      end
    end
    t.join
  end

  def roam
    id = @location.destinations.sample
    @location = @configuration.find_location(id)
    @logger.info("npc #{@name} moved to #{@location.name}")
  end
end
