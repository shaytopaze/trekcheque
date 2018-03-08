class Expense < ApplicationRecord

  monetize :amount_cents, numericality: true

  has_many :payees
  belongs_to :trip
  belongs_to :user

  validates :amount, presence: true
  validates :description, presence: true

end
