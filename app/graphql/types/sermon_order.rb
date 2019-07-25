class Types::SermonOrder < Types::BaseEnum
  value 'newest_first'
  value 'oldest_first'

  @@orders = {
    es: {
      'newest_first' => { recorded_at: :desc },
      'oldest_first' => { recorded_at: :asc },
    },
    ar: {
      'newest_first' => { recorded_at: :desc },
      'oldest_first' => { recorded_at: :asc },
    }
  }

  def self.order(db, order)
    @@orders[db][order]
  end
end
