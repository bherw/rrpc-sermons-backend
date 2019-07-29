FactoryBot.define do
  factory :speaker do
    name { Faker::Name.unique.name }
  end
end