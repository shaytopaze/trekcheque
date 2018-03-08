class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.references :trip, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.integer :amount_cents
      t.text :description

      t.timestamps
    end
  end
end
