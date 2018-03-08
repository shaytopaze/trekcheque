class Expense < ApplicationRecord

  has_many :payees
  belongs_to :trip
  belongs_to :user

  validates :amount, presence: true
  validates :description, presence: true

end

