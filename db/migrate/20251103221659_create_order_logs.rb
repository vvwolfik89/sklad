class CreateOrderLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :order_logs do |t|
      t.date
      t.timestamps
    end
  end
end
