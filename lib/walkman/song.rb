require "active_model"

module Walkman
  class Song
    include ActiveModel::Model

    attr_accessor :source_type, :source_id
    attr_accessor :title, :artist, :album
    attr_accessor :echonest_id
  end
end
