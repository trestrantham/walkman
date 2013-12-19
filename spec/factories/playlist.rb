FactoryGirl.define do
  factory :playlist, class: Walkman::Playlist do
    skip_create

    ignore do
      session_id { "ABCDEFG123456789" }
      songs { [] }
    end

    initialize_with do
      Walkman::Playlist.new(
        session_id: session_id,
        songs: songs
      )
    end
  end
end
