require "spec_helper"

describe Walkman::Player do
  let(:player) { Walkman::Player.instance }

  describe "#services" do
    it "returns a hash of all services this player knows about" do
      expect(player.services.keys).to include("Walkman::Services::Rdio")
    end
  end

  describe "#startup" do
    it "starts up all music services" do
      Walkman::Player::SERVICES.each do |service|
        service.any_instance.stub(:startup)
        expect_any_instance_of(service).to receive(:startup)
      end

      player.startup
    end
  end

  describe "#shutdown" do
    it "shuts down all music services" do
      Walkman::Player::SERVICES.each do |service|
        service.any_instance.stub(:shutdown)
        expect_any_instance_of(service).to receive(:shutdown)
      end

      player.shutdown
    end
  end

  describe "#play" do
    it "plays a song from a specific music service" do
      service = Walkman::Player::SERVICES.first
      song = Walkman::Song.new(source_type: service.name)

      expect_any_instance_of(service).to receive(:play)

      player.play(song)
    end
  end

  describe "#stop" do
    it "stops all music services" do
      Walkman::Player::SERVICES.each do |service|
        service.any_instance.stub(:stop)
        expect_any_instance_of(service).to receive(:stop)
      end

      player.stop
    end
  end
end
