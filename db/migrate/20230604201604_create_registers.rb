class CreateRegisters < ActiveRecord::Migration[7.0]
  def change
    create_table :registers do |t|
      t.string :name
      t.integer :department_id
      t.integer :user_id
      t.string :type
      t.json :data

      t.timestamps
    end
  end
end
