FactoryBot.define do
  factory :series do
    name { Faker::Lorem.sentence }
    speaker { create(:speaker) }
  end
end