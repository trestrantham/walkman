FactoryGirl.define do
  factory :song, class: Walkman::Song do
    skip_create

    sequence(:album)              { |x| "Album#{x}" }
    sequence(:artist)             { |x| "Artist#{x}" }
    sequence(:echonest_artist_id) { |x| "ARTISTID#{x}" }
    sequence(:echonest_song_id)   { |x| "SONGID#{x}" }
    sequence(:source_id)          { |x| "t#{x}" }
    source_type { Walkman::Player::SERVICES.shuffle.first.to_s }
    sequence(:title)              { |x| "Title#{x}" }
  end
end
