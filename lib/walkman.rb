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
    when "unknown"
      ::Logger::UNKNOWN
    when "fatal"
      ::Logger::FATAL
    when "error"
      ::Logger::ERROR
    when "warn"
      ::Logger::WARN
    when "info"
      ::Logger::INFO
    when "debug"
      ::Logger::DEBUG
    else
      raise "Unknown log level given #{log_level_string}"
    end
  end

  def self.echowrap
    @echowrap ||= Echowrap.configure do |config|
    end
  end
end
