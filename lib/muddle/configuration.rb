require "yaml"
require "logger"
require_relative "location/location"
require_relative "item/weapon"
require_relative "character/non_player_character"
require_relative "error/error"

class Configuration
  attr_reader :locations, :items, :npcs

  def initialize
    @locations = {}
    @items = {}
    @npcs = {}
    @logger = Logger.new(STDOUT)
  end

  def parse_dict(config)
    parse_items(config["items"])
    parse_locations(config["locations"])
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
      raise MissingItemsError.new("items cannot be empty")
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
      @logger.info("configured item: #{i}")
      @items[id] = i
    end
    @logger.info("configured #{@items.length} item(s)")
  end

  def parse_locations(locations)
    if locations.nil? or locations.length == 0
      raise MissingLocationsError.new("locations cannot be empty")
    end
    locations.each do |id, location|
      name = location["name"]
      description = location["description"]
      if location.key?("to")
        to = location["to"]
      else
        to = []
      end
      items = []
      if location.key?("items")
        target_items = location["items"]
        target_items.each do |target_item|
          if @items.key?(target_item)
            items.push(@items[target_item].clone)
          else
            raise UnknownItemError.new("unknown item #{target_item} in location #{id}")
          end
        end
      end
      l = Location.new(id, name, description, to)
      @logger.info("configured location: #{l}")
      @locations[id] = l
    end
    @locations.each do |_, location|
      location.destinations.each do |destination|
        unless @locations.key?(destination)
          raise UnknownLocationError.new("unknown destination #{destination}")
        end
      end
    end
    @logger.info("configured #{@locations.length} location(s)")
  end

  def parse_npcs(npcs)
    if npcs.nil? or npcs.length == 0
      raise MissingNpcsError.new("npcs cannot be empty")
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
      @logger.info("configured npc: #{n}")
      @npcs[id] = n
    end
    @logger.info("configured #{@npcs.length} npc(s)")
  end
end
