class AddListsToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :lists, :json
  end
end
