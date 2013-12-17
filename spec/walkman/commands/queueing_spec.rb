require "spec_helper"

describe Walkman::Commands::Queueing do
  let!(:player) { Walkman::Player.instance }
  let!(:remote_playlist) { double }

  before do
    Walkman.echowrap.stub(:playlist_dynamic_create) { remote_playlist }
    remote_playlist.stub(:session_id) { 1 }
  end

  describe ".play_artist" do
    it "queries echo nest for the songs by the given artist" do
      expect(Walkman.echowrap).to receive(:playlist_dynamic_create).with(anything)
      expect(remote_playlist).to receive(:session_id)

      expect(player.playlist).to be_nil

      Walkman::Commands::Queueing.play_artist("Radiohead")

      expect(player.playlist).to_not be_nil
      expect(player.playlist.instance_variable_get("@session_id")).to eq(1)
    end

    describe "songs found on echo nest" do
      it "adds songs to the current playlist" do
        expect(player.playlist).to be_nil

        Walkman::Commands::Queueing.play_artist("Radiohead")
      end
    end

    describe "no songs found on echo nest" do
      it "displays information about the failed search"
    end
  end

  describe ".play_album"
  describe ".play_song"
  describe ".play_album_by_artist"
  describe ".play_song_by_artist"

  describe ".play_like_artist"
  describe ".play_like_song_by_artist"
end
