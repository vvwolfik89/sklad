class CreateJoinTablePartnersOrders < ActiveRecord::Migration[7.0]
  def change
    create_join_table :orders, :partners do |t|
      t.index :order_id
      t.index :partner_id
    end
  end
end
