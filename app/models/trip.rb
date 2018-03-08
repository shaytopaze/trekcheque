class Trip < ApplicationRecord
  has_many :attendees
  has_many :expenses

  validates :name, presence: true

end
