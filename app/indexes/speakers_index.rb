class SpeakersIndex < Chewy::Index
  define_type Speaker do
    field :name, :description
  end
end
