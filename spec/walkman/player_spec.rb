require "spec_helper"

describe Walkman::Player do
  let!(:player) { Walkman.player }

  before do
    Walkman.echowrap.stub(:playlist_dynamic_feedback)
    Command.stub(:run)

    Walkman::Player::SERVICES.each do |service|
      service.any_instance.stub(:startup)
      service.any_instance.stub(:shutdown)
    end

    player.playlist = nil
    player.current_song = nil
  end

  it "responds to #playlist" do
    expect(player).to respond_to(:playlist)
  end

  describe "#services" do
    it "returns a hash of all services this player knows about" do
      expect(player.services.keys).to include("Walkman::Services::Rdio")
    end
  end

  describe "#startup" do
    it "starts up all music services" do
      Walkman::Player::SERVICES.each do |service|
        expect_any_instance_of(service).to receive(:startup)
      end

      player.startup
    end

    describe "play loop" do
      before do
        player.services.each_with_index do |(k, service), i|
          service.stub(:startup)
          service.stub(:shutdown)
        end

        player.startup
      end

      after do
        player.shutdown
      end

      it "calls #next if there is no current song" do
        player.current_song = nil

        expect(player).to receive(:next).at_least(1)

        player.play
        sleep 0.2
      end

      it "calls #stop if the last loop song is different than the current loop song" do
        player.current_song = create(:song)
        player.playlist = create(:playlist)
        player.playlist.add(create(:song))

        expect(player).to receive(:stop).at_least(1)

        player.play
        sleep 0.2
        player.current_song = create(:song)
        sleep 0.2
      end

      it "calls #play_song if the last loop song is nil" do
        player.current_song = create(:song)

        expect(player).to receive(:play_song).at_least(1)

        player.play
        sleep 0.2
      end
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
      player.startup

      Walkman::Player::SERVICES.each do |service|
        service.any_instance.stub(:play)
        expect_any_instance_of(service).to receive(:play)
        player.current_song = create(:song, source_type: service.name)
      end

      player.play
      sleep 0.1
      player.shutdown
    end
  end

  describe "#stop" do
    it "stops all music services" do
      Walkman::Player::SERVICES.each do |service|
        service.any_instance.stub(:stop)
        expect_any_instance_of(service).to receive(:stop)
      end

      player.stop
      sleep 0.2
    end
  end

  describe "#next" do
    let!(:song) { create(:song) }
    let!(:playlist) { create(:playlist) }

    before do
      player.playlist = playlist
      player.playlist.clear
    end

    it "plays the next song in the playlist" do
      player.playlist.add(song)
      player.current_song = nil

      expect {
        player.next
      }.to change {
        player.current_song
      }.from(nil).to(song)
    end

    it "stops playing if there are no more songs in the playlist queue" do
      player.playing = true
      player.current_song = song

      player.next

      expect(player.current_song).to be_nil
      expect(player.playing).to eq(false)
    end
  end
end
