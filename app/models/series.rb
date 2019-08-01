class Series < ApplicationRecord
  extend FriendlyId

  update_index 'speakers#speaker', :self

  friendly_id :name, use: :slugged
  validates :name, presence: true

  belongs_to :speaker
  has_many :sermons, -> { order(:recorded_at) }

  def should_generate_new_friendly_id?
    name_changed? || super
  end

  def update_indexes
    reload
    index = 0
    sermons.each do |sermon|
      index += 1
      sermon.update_columns(series_index: index)
    end
  end
end
