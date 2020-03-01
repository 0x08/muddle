
require_relative 'item'

class Weapon < Item

  def initialize(id, name, description, damage)
    @id = id
    @name = name
    @description = description
    @damage = damage
  end

  attr_reader :id, :name, :description, :damage

end