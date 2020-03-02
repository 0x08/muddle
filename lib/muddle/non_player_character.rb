class NonPlayerCharacter
  attr_reader :name, :description, :hitpoints, :id

  def initialize(id, name, description, hitpoints)
    @id = id
    @name = name
    @description = description
    @hitpoints = hitpoints
  end
end
