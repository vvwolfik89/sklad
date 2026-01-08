class CreateJoinTableProducTypesAndOrder < ActiveRecord::Migration[7.0]
  def change
    create_join_table :product_types, :orders do |t|
      t.index :product_type_id
      t.index :order_id
    end
  end
end
