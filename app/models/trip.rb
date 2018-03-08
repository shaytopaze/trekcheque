class Trip < ApplicationRecord
  monetize :price_per_night_cents, numericality: true

  has_many :attendees
  has_many :expenses
  has_many :users, :through => :attendees

  validates :name, presence: true

end
