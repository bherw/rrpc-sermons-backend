class SermonsIndex < Chewy::Index
  define_type Sermon do
    field :duration, type: 'long'
    field :recorded_at, type: 'date'
    field :series, :title, :scripture, :scripture_focus, :scripture_reading
    field :speaker, value: ->(sermon) { sermon.speaker.name }
    field :scripture_reading_might_be_focus, type: 'boolean'
    field :year, type: 'short', value: ->(sermon) { sermon.recorded_at.year }
  end
end
