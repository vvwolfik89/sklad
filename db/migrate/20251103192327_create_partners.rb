class CreatePartners < ActiveRecord::Migration[7.0]
  def change
    create_table :partners do |t|
      t.string :name
      t.text :description
      t.string :email
      t.string :phone_number
      t.string :address
      t.string :legal_address

      t.timestamps
    end
  end
end
