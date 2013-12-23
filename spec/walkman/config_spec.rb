require "spec_helper"

describe Walkman::Config do
  let!(:config) { Walkman::Config.new }

  it "ensures only one Config object exists" do
    config = Walkman.config

    expect(config).to eq(Walkman.config)
  end

  describe "global configs" do
    it "has a log level" do
      expect(config.log_level).to eq("debug")

      config.log_level = "info"

      expect(config.log_level).to eq("info")
    end
  end

  describe "server configs" do
    it "has a server host" do
      expect(config.server_host).to eq("localhost")
    end

    it "has a server port" do
      expect(config.server_port).to eq(27001)
    end

    it "has a DRb URI" do
      expect(config.drb_uri).to eq("druby://localhost:27001")
    end
  end

  describe "echo nest configs" do
    it "has a echo nest api key" do
      expect(config.echonest_api_key).to be_nil
    end

    it "has a echo nest consumer key" do
      expect(config.echonest_consumer_key).to be_nil
    end

    it "has a echo nest shared secret" do
      expect(config.echonest_shared_secret).to be_nil
    end

    it "has a echo nest catalog id" do
      expect(config.echonest_catalog_id).to be_nil
    end
  end

  describe "rdio configs" do
    it "has a rdio player url" do
      expect(config.rdio_player_url).to eq("http://localhost:4567/rdio")
    end

    it "has a rdio playback token" do
      expect(config.rdio_playback_token).to be_nil
    end

    it "has a rdio browser path" do
      expect(config.rdio_browser_path).to eq('/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --no-process-singleton-dialog')
    end
  end

  it "can load config values from a given YAML file" do
    config_file = File.join(File.dirname(__FILE__), "..", "fixtures", "walkman.yml")
    config.load_file(config_file)

    expect(config.echonest_api_key).to eq("ABC")
    expect(config.echonest_consumer_key).to eq("DEF")
    expect(config.echonest_shared_secret).to eq("GHI")
    expect(config.echonest_catalog_id).to eq("JKL")
    expect(config.rdio_playback_token).to eq("MNO")
  end
end
