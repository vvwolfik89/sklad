class CreateOrderDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :order_details do |t|
      t.integer :order_log_id
      t.integer :partner_id

      t.timestamps
    end
  end
end
