class CreateSchedules < ActiveRecord::Migration[7.0]
  def change
    create_table :schedules do |t|
      t.references :journal, null: false, foreign_key: true
      t.json :times     # массив строк: ['08:00', '17:00']
      t.json :days # массив чисел: [0,1,2,3,4,5,6]
      t.timestamps
    end
  end
end
