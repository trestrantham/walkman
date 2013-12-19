FactoryGirl.define do
  factory :playlist, class: Walkman::Playlist do
    skip_create

    ignore do
      artist { "Artist" }
      auto_queue { false }
      session_id { "ABCDEFG123456789" }
      songs { [] }
      type { "artist" }
    end

    initialize_with do
      Walkman::Playlist.new(
        session_id: session_id,
        songs: songs
      )
    end

    trait :dynamic_artist do
      initialize_with do
        Walkman::Playlist.new(
          artist: artist,
          auto_queue: auto_queue,
          session_id: session_id,
          songs: songs,
          type: type
        )
      end
    end
  end
end
