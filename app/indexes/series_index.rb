class SeriesIndex < Chewy::Index
  define_type Series do
    field :name
    field :speaker, value: ->(series) { series.speaker.name }
  end
end
