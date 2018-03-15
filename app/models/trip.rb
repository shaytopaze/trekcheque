class Trip < ApplicationRecord
  monetize :price_per_night_cents, :total_possible_cost_cents, :total_confirmed_cost_cents, numericality: true

  has_many :attendees
  has_many :expenses
  has_many :users, :through => :attendees

  validates :name, presence: true, length: { minimum: 1, maximum: 30 }
  validates :number_of_possible_attendees, presence: true

  validate :validate_date

  URL_REGEXP = /\A(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?\z/ix
  validates :accomodation_url, :allow_blank => true, format: { with: URL_REGEXP, message: 'You provided an invalid link! Please make sure it starts with http(s)://' }

  def validate_date
    errors.add(:start_date, 'must be earlier than end date') if
    self.start_date >= self.end_date
  end

end

