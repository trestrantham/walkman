require "active_model"

module Walkman
  class Song
    include ActiveModel::Model

    attr_accessor :source_type, :source_id
    attr_accessor :title, :artist, :album
    attr_accessor :echonest_song_id, :echonest_artist_id
  end
end
