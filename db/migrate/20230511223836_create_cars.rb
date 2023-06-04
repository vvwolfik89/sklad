class CreateCars < ActiveRecord::Migration[7.0]
  def change
    create_table :cars do |t|
      t.string :registration_number
      t.string :model
      t.string :brand
      t.date :date_registration
      t.date :date_of_manufacture
      t.integer :fuel_type
      t.string :vin
      t.string :vin_equipment
      t.date :date_to
      t.date :date_safety

      t.timestamps
    end
  end
end
