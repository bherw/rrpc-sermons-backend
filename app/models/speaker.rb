class Speaker < ApplicationRecord
  include ImageUploader[:photo]
  extend FriendlyId

  update_index 'speakers#speaker', :self

  friendly_id :name, use: :slugged
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  has_many :sermons, -> { order(:recorded_at) }

  def photo_url
    photo ? photo.url : nil
  end

  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
