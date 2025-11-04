class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :number
      t.json :data_list, default: {}
      t.timestamps
    end
  end
end
