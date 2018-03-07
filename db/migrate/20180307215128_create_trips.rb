class CreateTrips < ActiveRecord::Migration[5.1]
  def change
    create_table :trips do |t|
      t.string :name
      t.string :accomodation_url
      t.integer :price_per_night
      t.integer :number_of_possible_attendees
      t.date :start_date
      t.date :end_date
      t.integer :total_possible_cost
      t.integer :total_confirmed_cost
      t.boolean :locked

      t.timestamps
    end
  end
end
