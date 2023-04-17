class AddDataToUsers < ActiveRecord::Migration[7.0]
  def change
    change_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :patronymic
      t.date :bday
    end
  end
end
