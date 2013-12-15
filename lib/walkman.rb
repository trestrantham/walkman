require "walkman/services/base"
require "walkman/services/rdio"
require "walkman/services/rdio/rdio_player"

require "walkman/player"
require "walkman/playlist"
require "walkman/song"

require "walkman/commands/controls"
require "walkman/commands/information"
require "walkman/commands/queueing"

module Walkman
  def self.logger
    @logger ||= begin
      $stdout.sync = true
      Logger.new($stdout)
    end
  end

  def self.log_level(level)
    self.logger.level = begin
      case level
      when :unknown
        Logger::UNKNOWN
      when :fatal
        Logger::FATAL
      when :error
        Logger::ERROR
      when :warn
        Logger::WARN
      when :info
        Logger::INFO
      when :debug
        Logger::DEBUG
      else
        Logger::INFO
      end
    end
  end

  log_level(:info)
end
