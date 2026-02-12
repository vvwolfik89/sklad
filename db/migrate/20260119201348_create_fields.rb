class CreateFields < ActiveRecord::Migration[7.0]
  def change
    create_table :fields do |t|
      t.references :journal, null: false, foreign_key: true
      t.string :name, null: false
      t.string :field_type, null: false  # text, date, user_select и т. д.
      t.string :related_model             # 'User', 'Car'
      t.string :display_field           # 'full_name', 'license_plate'
      t.json :options                   # для type=select (массив вариантов)
      t.timestamps
    end
  end
end
