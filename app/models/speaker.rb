class Speaker < ApplicationRecord
  include ImageUploader[:photo]
  extend FriendlyId

  update_index 'speakers#speaker', :self

  friendly_id :name, use: :slugged
  validates :name, presence: true

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
