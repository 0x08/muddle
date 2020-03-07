class MuddleEngine
  def run(configuration)
    configuration.npcs.each do |_, npc|
      npc.run
    end
  end
end
