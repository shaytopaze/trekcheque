class Attendee < ApplicationRecord
  belongs_to :trip
  belongs_to :user
end
