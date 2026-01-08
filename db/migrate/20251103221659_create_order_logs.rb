class CreateOrderLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :order_logs do |t|
      t.integer :type_orders
      t.date :date
      t.timestamps
    end
  end
end
