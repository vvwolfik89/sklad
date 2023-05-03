class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :name
      t.string :action_name
      t.string :class_name
      t.integer :permission_category_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
