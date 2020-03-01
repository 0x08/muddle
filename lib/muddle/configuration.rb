
require 'yaml'
require 'logger'
require_relative 'location'
require_relative 'weapon'

class Configuration

  attr_reader :locations, :items

  def initialize
    @locations = {}
    @items = {}
    @logger = Logger.new(STDOUT)
  end

  def parse_dict(config)
    @logger.debug("loading configuration: #{config}")
    parse_locations(config['locations'])
    parse_items(config['items'])
  end


  def parse(filename)
    parse_dict(YAML.load_file(filename))
  end

  private

  def parse_items(items)
    if items.nil? or items.length == 0
      raise "items cannot be empty"
    end
    items.each do |id, item|
      name = item['name']
      description = item['description']
      case item['type']
      when 'weapon'
        damage = item['damage']
        i = Weapon.new(id, name, description, damage)
      else
        raise "unknown item type #{item['type']}"
      end
      @items[id] = i
    end
  end

  def parse_locations(locations)
    if locations.nil? or locations.length == 0
      raise "locations cannot be empty"
    end
    locations.each do |id, location|
      name = location['name']
      description = location['description']
      to = location['to']
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

end