class Attendee < ApplicationRecord

  monetize :balance_cents, numericality: true

  belongs_to :trip
  belongs_to :user

end
