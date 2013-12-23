require "spec_helper"

describe Walkman::Commands::Playlist do
  let!(:player) { Walkman.player }
  let!(:playlist) { Walkman::Playlist.new }

  before do
    Walkman.echowrap.stub(:playlist_dynamic_feedback)
  end

  describe ".like" do
    it "updates the song's like count" do
      player.playlist = playlist
      song = create(:song)
      player.current_song = song

      expect(player.playlist).to receive(:feedback).with(:favorite, song)

      expect(Walkman::Commands::Playlist.like).to eq("Awesome! I'll play more songs like this.")
    end

    it "returns a notification if there is not a current song" do
      player.current_song = nil

      expect(Walkman::Commands::Playlist.like).to eq("No music is playing. Are you hearing things?")
    end
  end
end
