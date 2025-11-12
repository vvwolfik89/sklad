class AddOrderIdToOrderDetails < ActiveRecord::Migration[7.0]
  def change
    change_table :order_details do |t|
      t.index :order_log_id
    end
  end
end
