module Types
  class SermonType < Types::BaseObject
    field :identifier, ID, null: false
    field :title, String, null: false
    field :scripture_reading, String, null: false
    field :scripture_focus, String, null: true
    field :speaker, Types::SpeakerType, null: false
    field :series, Types::SeriesType, null: true
    field :series_index, Int, null: true
    field :recorded_at, GraphQL::Types::ISO8601DateTime, null: false
    field :audio_url, String, null: false
    field :audio_waveform_url, String, null: true
    field :duration, Int, null: false

    def series
      object.series_id ? ::RecordLoader.for(Series).load(object.series_id) : nil
    end

    def speaker
      ::RecordLoader.for(Speaker).load(object.speaker_id)
    end
  end
end
