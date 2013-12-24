require "echowrap"

require "walkman/config"

require "walkman/services/base"
require "walkman/services/rdio"
require "walkman/services/rdio/rdio_player"

require "walkman/player"
require "walkman/playlist"
require "walkman/song"

require "walkman/commands/controls"
require "walkman/commands/information"
require "walkman/commands/player"
require "walkman/commands/playlist"
require "walkman/commands/queueing"

require "walkman/cli"

module Walkman
  def self.logger
    @@logger ||= ::Logger.new(STDOUT).tap do |l|
      l.level = log_level(Walkman.config.log_level)
      l.formatter = proc do |severity, _, _, message|
        "[walkman](#{severity.downcase}): #{message}\n"
      end
    end
  end

  def self.log_level(log_level_string)
    case log_level_string.to_s
    when "debug"
      ::Logger::DEBUG
    when "info"
      ::Logger::INFO
    when "warn"
      ::Logger::WARN
    when "error"
      ::Logger::ERROR
    when "fatal"
      ::Logger::FATAL
    else
      raise "Unknown log level given #{log_level_string}"
    end
  end

  def self.echowrap
    @echowrap ||= Echowrap.configure do |config|
      config.api_key       = Walkman.config.echonest_api_key
      config.consumer_key  = Walkman.config.echonest_consumer_key
      config.shared_secret = Walkman.config.echonest_shared_secret
    end
  end
end
