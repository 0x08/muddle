require_relative "muddle/configuration"
require_relative "muddle/muddle_engine"

require "logger"

logger = Logger.new(STDOUT)

logger.info("reading configuration")
configuration = Configuration.new
configuration.parse("/etc/muddle/muddle.yaml")

logger.info("starting engine")
engine = MuddleEngine.new
engine.run(configuration)
