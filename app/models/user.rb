class User < ApplicationRecord
    has_many :payees
    has_many :attendees
    has_many :expenses
end
