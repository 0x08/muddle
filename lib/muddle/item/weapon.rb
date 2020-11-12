require_relative "item"

class Weapon < Item
  def initialize(id, name, description, damage)
    super(id, name, description)
    @damage = damage
  end

  attr_reader :id, :name, :description, :damage
end
