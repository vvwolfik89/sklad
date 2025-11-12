class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.index :partner_id
      t.index :order_log_id
      t.timestamps
    end
  end
end
