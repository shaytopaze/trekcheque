class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :accomodation_url
      t.string :start_location
      t.string :end_location
      t.integer :price_per_night_cents
      t.integer :number_of_possible_attendees
      t.date :start_date
      t.date :end_date
      t.integer :total_possible_cost_cents
      t.integer :total_confirmed_cost_cents
      t.boolean :started
      t.boolean :ended

      t.timestamps
    end
  end
end
