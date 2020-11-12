class Item
  def initialize(id, name, description)
    @id = id
    @name = name
    @description = description
  end

  def to_s
    @name
  end
end
