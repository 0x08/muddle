
require 'yaml'
require 'logger'
require_relative 'location'

class Configuration

  attr_reader :locations

  def initialize
    @locations = {}
    @logger = Logger.new(STDOUT)
  end

  def parse_dict(config)
    @logger.debug("loading configuration: #{config}")
    config['locations'].each do |id, location|
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

  def parse(filename)
    parse_dict(YAML.load_file(filename))
  end

end