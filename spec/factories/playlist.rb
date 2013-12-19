FactoryGirl.define do
  factory :playlist, class: Walkman::Playlist do
    skip_create

    ignore do
      session_id { "ABCDEFG123456789" }
      songs { [create(:song)] }
    end

    initialize_with do
      Walkman::Playlist.new(
        songs: songs,
        session_id: session_id
      )
    end
  end
end
