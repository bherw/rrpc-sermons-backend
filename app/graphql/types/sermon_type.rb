module Types
  class SermonType < Types::BaseObject
    field :identifier, String, null: false
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
      return nil unless object.series_id
      return object.series if object.association_cached?(:series)
      CacheQL::RecordLoader.for(Series).load(object.series_id)
    end

    def speaker
      return object.speaker if object.association_cached?(:speaker)
      CacheQL::RecordLoader.for(Speaker).load(object.speaker_id)
    end
  end
end
