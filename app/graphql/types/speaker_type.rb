module Types
  class SpeakerType < Types::BaseObject
    field :name, String, null: false
    field :photo_url, String, null: true
    field :description, String, null: true
  end
end
