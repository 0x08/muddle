class Location
  def initialize(id, name, description, destinations)
    @id = id
    @name = name
    @description = description
    @destinations = destinations
  end

  def to_s
    @name
  end

  attr_reader :id, :name, :description, :destinations
end
