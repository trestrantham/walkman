require "yaml"

module Walkman
  def self.config
    @@config ||= Config.new.tap do |config|
      config.load_file("~/.walkman")
    end
  end

  class Config
    # logger
    attr_accessor :log_level

    # cli/drb
    attr_reader   :server_host
    attr_reader   :server_port
    attr_reader   :drb_uri

    # echonest
    attr_reader   :echonest_api_key
    attr_reader   :echonest_consumer_key
    attr_reader   :echonest_shared_secret
    attr_reader   :echonest_catalog_id

    # rdio
    attr_reader   :rdio_player_url
    attr_reader   :rdio_playback_token
    attr_reader   :rdio_browser_path

    def initialize
      # global
      @log_level   = "debug"

      # server
      @server_host = "localhost"
      @server_port = 27001
      @drb_uri     = "druby://#{@server_host}:#{@server_port}"

      # echo nest
      @echonest_api_key       = nil
      @echonest_consumer_key  = nil
      @echonest_shared_secret = nil
      @echonest_catalog_id    = nil

      # rdio service
      @rdio_player_url        = "http://localhost:4567/rdio"
      @rdio_playback_token    = nil
      @rdio_browser_path      = '/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-process-singleton-dialog' # must be single quotes
    end

    def load_file(config_file)
      file = File.expand_path(config_file)

      if File.file?(file)
        configs = YAML.load(File.read(file))
        load_global_configs(configs)
        load_server_configs(configs["server"])
        load_echonest_configs(configs["echonest"])
        load_rdio_configs(configs["rdio"])
      end
    end

    protected

    def load_global_configs(configs)
      @log_level = configs["log_level"] if configs["log_level"]
    end

    def load_server_configs(configs)
      return unless configs

      @server_host = configs["host"] if configs["host"]
      @server_port = configs["port"] if configs["port"]
      @drb_uri     = "druby://#{@server_host}:#{@server_port}"
    end

    def load_echonest_configs(configs)
      return unless configs

      @echonest_api_key       = configs["api_key"]
      @echonest_consumer_key  = configs["consumer_key"]
      @echonest_shared_secret = configs["shared_secret"]
      @echonest_catalog_id    = configs["catalog_id"]
    end

    def load_rdio_configs(configs)
      return unless configs

      @rdio_playback_token = configs["playback_token"]
      @rdio_player_url     = configs["player_url"] if configs["player_url"]
      @rdio_browser_path   = configs["browser_path"] if configs["browser_path"]
    end
  end
end
