require_relative "muddle/configuration"

configuration = Configuration.new
configuration.parse ARGV[0]
