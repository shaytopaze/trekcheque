class Expense < ApplicationRecord

  monetize :amount_cents, numericality: true

  has_many :payees
  belongs_to :trip
  belongs_to :user

  accepts_nested_attributes_for :payees

  validates :amount, presence: true
  validates :description, presence: true, length: { maximum: 100 }

end

