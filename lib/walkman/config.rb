module Walkman
  def self.config
    @@config ||= Config.new
  end

  class Config
    attr_accessor :log_level
    attr_accessor :server_host
    attr_accessor :server_port
    attr_reader   :drb_uri

    def initialize
      @log_level   = :debug
      @server_host = "localhost"
      @server_port = 27001
      @drb_uri     = "druby://#{@server_host}:#{@server_port}"
    end
  end
end
