class SermonsIndex < Chewy::Index
  define_type Sermon do
    field :duration, type: 'long'
    field :recorded_at, type: 'date'
    field :title, :scripture, :scripture_focus, :scripture_reading
    field :series, value: ->(sermon) { sermon.series ? sermon.series.name : nil }
    field :series_index, type: 'short'
    field :speaker, value: ->(sermon) { sermon.speaker.name }
    field :scripture_reading_might_be_focus, type: 'boolean'
    field :year, type: 'short', value: ->(sermon) { sermon.recorded_at.year }
  end

  # XXX: Chewy will redefine Query later, but we need to do it here in order to register the
  # connection implementation.
  class Query; end

  GraphQL::Relay::BaseConnection.register_connection_implementation(SermonsIndex::Query, Types::ChewyRelationConnection)
end
