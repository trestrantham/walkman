require "spec_helper"

describe Walkman::Player do
  let!(:player) { Walkman::Player.instance }

  before :all do
    Walkman::Player.instance.startup
  end

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
      player.playlist = Walkman::Playlist.new(song)

      expect_any_instance_of(service).to receive(:play)

      player.play

      sleep 0.5 # have to give the play loop a chance to pick up the song
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

  describe "#next" do
    it "plays the next song in the playlist" do
      pending
    end

    it "stops playing if there are no more songs in the playlist queue" do
      pending
    end
  end

  it "responds to #playlist" do
    expect(player).to respond_to(:playlist)
  end
end
