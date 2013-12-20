module Walkman
  def self.config
    @@config ||= Config.new
  end

  class Config
    # logger
    attr_accessor :log_level

    # cli/drb
    attr_accessor :server_host
    attr_accessor :server_port
    attr_reader   :drb_uri

    # echonest
    attr_reader   :echonest_api_key
    attr_reader   :echonest_consumer_key
    attr_reader   :echonest_shared_secret

    # rdio
    attr_accessor :rdio_url
    attr_accessor :browser_app

    def initialize
      @log_level   = :debug
      @server_host = "localhost"
      @server_port = 27001
      @drb_uri     = "druby://#{@server_host}:#{@server_port}"

      # echo nest
      @echonest_api_key       = "8DKQQ3JDRGSS4OFDZ"
      @echonest_consumer_key  = "a56ef5ddc2fd5b1c0da6df4250642611"
      @echonest_shared_secret = "8xd5/ZEfRrezQGo5jX1naA"

      # rdio service
      @rdio_url    = "http://localhost:4567/rdio"
      @browser_app = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-process-singleton-dialog --incognito'
    end
  end
end
