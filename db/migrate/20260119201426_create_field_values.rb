class CreateFieldValues < ActiveRecord::Migration[7.0]
  def change
    create_table :field_values do |t|
      t.references :entry, null: false, foreign_key: true
      t.references :field, null: false, foreign_key: true
      t.text :value                     # для text, number, date и т. д.
      t.integer :related_record_id   # для user_select, car_select
      t.timestamps
    end

    # Индексы для ускорения запросов
    add_index :field_values, [:entry_id, :field_id]
    add_index :field_values, :related_record_id
  end
end
