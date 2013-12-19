require "spec_helper"

describe Walkman::Commands::Queueing do
  let!(:player) { Walkman::Player.instance }
  let!(:song) { create(:echowrap_song, artist_name: "Artist") }
  let!(:playlist_dynamic_create) { create(:echowrap_playlist, :dynamic_create) }
  let!(:playlist_dynamic_next) { create(:echowrap_playlist, :dynamic_next, songs: [song]) }

  before :each do
    player.playlist = nil
    player.current_song = nil

    Walkman.echowrap.stub(:playlist_dynamic_create) { playlist_dynamic_create }
    Walkman.echowrap.stub(:playlist_dynamic_next) { playlist_dynamic_next }
  end

  describe ".play_artist" do
    it "queries echo nest for the songs by the given artist" do
      expect(player.playlist).to be_nil

      Walkman::Commands::Queueing.play_artist("Artist") # from stub

      expect(player.playlist).to_not be_nil
      expect(player.playlist.instance_variable_get("@session_id")).to eq(playlist_dynamic_create.session_id)
    end

    describe "songs found on echo nest" do
      it "adds songs to the current playlist" do
        expect(player.playlist).to be_nil

        Walkman::Commands::Queueing.play_artist("Artist") # from stub

        expect(player.playlist).to_not be_nil
        expect(player.playlist.size).to eq(1)

        expect(player.current_song.artist).to eq(song.artist_name)
        expect(player.current_song.title).to eq(song.title)
      end
    end

    describe "no songs found on echo nest" do
      it "displays information about the failed search" do
        playlist_dynamic_next = create(:echowrap_playlist, :dynamic_next, songs: [])
        Walkman.echowrap.stub(:playlist_dynamic_next) { playlist_dynamic_next }

        expect(player.playlist).to be_nil

        expect(Walkman::Commands::Queueing.play_artist("Foo")).to eq("That artist couldn't be queued up")
        expect(player.playlist).to_not be_nil
        expect(player.playlist.size).to be(0)
      end
    end
  end

  describe ".play_album"
  describe ".play_song"
  describe ".play_album_by_artist"
  describe ".play_song_by_artist"

  describe ".play_like_artist"
  describe ".play_like_song_by_artist"
end
