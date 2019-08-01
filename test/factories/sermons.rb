include ActionDispatch::TestProcess

FactoryBot.define do
  factory :sermon do
    title { Faker::Lorem.sentence() }
    sequence(:identifier) { |n| "2010-01-#{n}AM" }
    sequence(:scripture_reading) { |n| "Scripture #{n}" }
    recorded_at { Time.now }
    audio { fixture_file_upload('test/fixtures/files/one-second-of-silence.mp3', 'audio/mpeg') }
    speaker { create(:speaker) }
  end
end