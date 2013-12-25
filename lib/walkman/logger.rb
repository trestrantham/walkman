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
end
