class CreateEntries < ActiveRecord::Migration[7.0]
  def change
    create_table :entries do |t|
      t.references :journal, null: false, foreign_key: true
      t.references :creator, null: false, foreign_key: { to_table: :users }
      t.date :date, null: false        # дата записи
      t.timestamps
    end

  end
end
