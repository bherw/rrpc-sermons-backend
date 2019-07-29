module Types
  class SeriesType < Types::BaseObject
    field :name, String, null: false
    field :speaker, Types::SpeakerType, null: false
    field :sermons_count, Int, null: false

    def speaker
      ::RecordLoader.for(Speaker).load(object.speaker_id)
    end
  end
end
