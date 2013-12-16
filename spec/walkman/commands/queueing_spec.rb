require "spec_helper"

describe Walkman::Commands::Queueing do
  let!(:player) { Walkman::Player.instance }

  describe "play_artist"
  describe "play_album"
  describe "play_song"
  describe "play_album_by_artist"
  describe "play_song_by_artist"

  describe "play_like_artist"
  describe "play_like_song_by_artist"


  describe ".play_artist" do
    it "queries echo nest for the songs by the given artist"

    describe "songs found on echo nest" do
      it "adds songs to the current playlist"
    end

    describe "no songs found on echo nest" do
      it "displays information about the failed search"
    end
  end
end
