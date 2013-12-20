require "spec_helper"

describe Walkman::Commands::Information do
  let(:player) { Walkman.player }
  let(:song) { Walkman::Song.new(title: "Bar", artist: "Foo", album: "Baz") }

  describe ".now_playing" do
    it "returns track info about the current song if playing" do
      player.current_song = song

      expect(Walkman::Commands::Information.now_playing).to eq("♫ Now playing Bar by Foo")
    end

    it "returns a notice if no song is playing" do
      player.current_song = nil

      expect(Walkman::Commands::Information.now_playing).to eq("No music is playing.")
    end
  end

  describe ".up_next" do
    before :each do
      player.playlist = Walkman::Playlist.new
      5.times { player.playlist.add(song) }
    end

    it "shows the next 5 songs in the playlist" do
      expect(Walkman::Commands::Information.up_next).to eq(
        "Foo - Bar\n" +
        "Foo - Bar\n" +
        "Foo - Bar\n" +
        "Foo - Bar\n" +
        "Foo - Bar\n"
      )
    end

    it "shows the specified number of songs in the playlist" do
      expect(Walkman::Commands::Information.up_next(3)).to eq(
        "Foo - Bar\n" +
        "Foo - Bar\n" +
        "Foo - Bar\n"
      )
    end
  end
end
