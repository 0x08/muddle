require "yaml"
require "logger"
require_relative "location/location"
require_relative "item/weapon"
require_relative "character/non_player_character"

class Configuration
  attr_reader :locations, :items, :npcs

  def initialize
    @locations = {}
    @items = {}
    @npcs = {}
    @logger = Log4r::Logger["muddle"]
  end

  def parse_dict(config)
    @logger.debug("loading configuration: #{config}")
    parse_locations(config["locations"])
    parse_items(config["items"])
    parse_npcs(config["npcs"])
  end

  def parse(filename)
    parse_dict(YAML.load_file(filename))
  end

  def find_location(id)
    @locations.each do |location_id, location|
      return location if location_id == id
    end
  end

  private

  def parse_items(items)
    if items.nil? or items.length == 0
      raise "items cannot be empty"
    end
    items.each do |id, item|
      name = item["name"]
      description = item["description"]
      case item["type"]
      when "weapon"
        damage = item["damage"]
        i = Weapon.new(id, name, description, damage)
      else
        raise "unknown item type #{item["type"]}"
      end
      @items[id] = i
    end
  end

  def parse_locations(locations)
    if locations.nil? or locations.length == 0
      raise "locations cannot be empty"
    end
    locations.each do |id, location|
      name = location["name"]
      description = location["description"]
      to = location["to"]
      l = Location.new(id, name, description, to)
      @locations[id] = l
    end
    @locations.each do |_, location|
      location.destinations.each do |destination|
        unless @locations.key?(destination)
          raise "unknown destination #{destination}"
        end
      end
    end
  end

  def parse_npcs(npcs)
    if npcs.nil? or npcs.length == 0
      raise "npcs cannot be empty"
    end
    npcs.each do |id, npc|
      name = npc["name"]
      description = npc["description"]
      hitpoints = npc["hitpoints"]
      if npc["location"].nil?
        raise "missing npc location"
      end
      location = find_location(npc["location"])
      if location.nil?
        raise "unknown npc location #{npc["location"]}"
      end
      n = NonPlayerCharacter.new(id, name, description, hitpoints, location, self)
      @npcs[id] = n
    end
  end
end
