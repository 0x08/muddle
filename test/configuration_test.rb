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

  end

  def test_broken_destination
    assert_raises RuntimeError do
      Configuration.new.parse_dict({"locations" => {"beach" => {"name" => "name", "desciption" => "description", "to" => ["nowhere"]}}})
    end
  end

end