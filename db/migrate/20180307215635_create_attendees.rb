class CreateAttendees < ActiveRecord::Migration[5.1]
  def change
    create_table :attendees do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :balance_cents

      t.timestamps
    end
  end
end
