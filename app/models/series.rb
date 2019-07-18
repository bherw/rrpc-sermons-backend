class Series < ApplicationRecord
  extend FriendlyId

  update_index 'speakers#speaker', :self

  belongs_to :speaker
  friendly_id :name, use: :slugged
  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
