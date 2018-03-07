class Expense < ApplicationRecord
  has_many :payees
  belongs_to :trip
  belongs_to :user
end
