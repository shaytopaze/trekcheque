class Trip < ApplicationRecord
  monetize :price_per_night_cents, :total_possible_cost_cents, :total_confirmed_cost_cents, numericality: true

  has_many :attendees
  has_many :expenses
  has_many :users, :through => :attendees

  validates :name, presence: true

end
