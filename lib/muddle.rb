require_relative "muddle/configuration"
require_relative "muddle/muddle_engine"

require "log4r"
require "log4r/yamlconfigurator"

Log4r::YamlConfigurator.load_yaml_file("/etc/muddle/log4r.yaml")

logger = Log4r::Logger["muddle"]

logger.info("reading configuration")
configuration = Configuration.new
configuration.parse("/etc/muddle/muddle.yaml")

logger.info("starting engine")
engine = MuddleEngine.new
engine.run(configuration)
