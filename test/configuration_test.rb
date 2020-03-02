require 'minitest/autorun'
require_relative '../lib/muddle/configuration'

class ConfigurationTest < Minitest::Test

  def test_parse

    dictionary =
        {
            "locations" =>
                {
                    "beach" => {
                        "name" => "The beach",
                        "description" => "You are on a beach. There is an old, beached shipwreck here covered in barnacles.",
                        "to" => ["north_beach"]
                    },
                    "north_beach" => {
                        "name" => "North beach",
                        "description" => "You are north of the beach landing.",
                        "to" => ["beach"]
                    }
                },
            "items" =>
                {
                    "rusty_sword" => {
                        "name" => "Rusty old sword",
                        "description" => "It looks like this sword has been lying in the sand for a long time. It's very rusty.",
                        "type" => "weapon",
                        "damage" => 1
                    }
                },
            "npcs" =>
                {
                    "drunken_sailor" => {
                        "name" => "Drunken sailor",
                        "description" => "This sailor has obviously had a little too much rum.",
                        "hitpoints" => 10
                    }
                }
        }

    config = Configuration.new
    config.parse_dict(dictionary)

    assert config.locations != nil
    assert_equal 2, config.locations.size

    assert_equal "beach", config.locations['beach'].id
    assert_equal "The beach", config.locations['beach'].name
    assert_equal "You are on a beach. There is an old, beached shipwreck here covered in barnacles.", config.locations['beach'].description
    assert_equal ["north_beach"], config.locations['beach'].destinations

    assert_equal "north_beach", config.locations['north_beach'].id
    assert_equal "North beach", config.locations['north_beach'].name
    assert_equal "You are north of the beach landing.", config.locations['north_beach'].description
    assert_equal ["beach"], config.locations['north_beach'].destinations

    assert config.items != nil
    assert 1, config.items.size

    assert_equal "rusty_sword", config.items['rusty_sword'].id
    assert_equal "Rusty old sword", config.items['rusty_sword'].name
    assert_equal "It looks like this sword has been lying in the sand for a long time. It's very rusty.", config.items['rusty_sword'].description
    assert_equal 1, config.items['rusty_sword'].damage

    assert config.npcs != nil
    assert 1, config.npcs.size

    assert_equal "drunken_sailor", config.npcs['drunken_sailor'].id
    assert_equal "Drunken sailor", config.npcs['drunken_sailor'].name
    assert_equal "This sailor has obviously had a little too much rum.", config.npcs['drunken_sailor'].description
    assert_equal 10, config.npcs['drunken_sailor'].hitpoints

  end

  def test_broken_destination
    assert_raises RuntimeError do
      Configuration.new.parse_dict({"locations" => {"beach" => {"name" => "name", "description" => "description", "to" => ["nowhere"]}}})
    end
  end

  def test_empty_config
    assert_raises RuntimeError do
      Configuration.new.parse_dict({})
    end
  end

  def test_empty_locations
    assert_raises RuntimeError do
      Configuration.new.parse_dict({"locations" => {}})
    end
  end

  def test_empty_items
    assert_raises RuntimeError do
      Configuration.new.parse_dict({"items" => {}})
    end
  end

  def test_empty_npcs
    assert_raises RuntimeError do
      Configuration.new.parse_dict({"npcs" => {}})
    end
  end

end