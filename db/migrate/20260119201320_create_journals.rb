class CreateJournals < ActiveRecord::Migration[7.0]
  def change
    create_table :journals do |t|
      t.string :title, null: false
      t.text :description

      t.timestamps
    end
  end
end
