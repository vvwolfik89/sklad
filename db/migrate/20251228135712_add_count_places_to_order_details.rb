class AddCountPlacesToOrderDetails < ActiveRecord::Migration[7.0]
  def change
    add_column :order_details, :count_places, :integer
  end
end
