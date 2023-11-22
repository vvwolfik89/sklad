class CreateCarInspection < ActiveRecord::Migration[7.0]
  def change
    create_table :car_inspections do |t|
      t.integer :user_id
      t.integer :car_id
      t.string :notes
      t.json :elements
      t.timestamps
    end
  end
end
