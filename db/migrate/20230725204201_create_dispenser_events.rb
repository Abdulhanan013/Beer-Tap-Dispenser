class CreateDispenserEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :dispenser_events do |t|
      t.references :dispenser, null: false, foreign_key: true
      t.boolean :status
      t.datetime :opened_at
      t.datetime :closed_at
      t.float :total_price

      t.timestamps
    end
  end
end
