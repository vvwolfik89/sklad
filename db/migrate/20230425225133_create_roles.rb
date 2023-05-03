class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :title
      t.text :description
      t.integer :role_type, default: 0

      t.timestamps
    end
  end
end
