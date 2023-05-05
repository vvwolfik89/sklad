class AddedDescriptionToPermission < ActiveRecord::Migration[7.0]
  def change
    change_table :permissions do |t|
      t.string :description

    end
    remove_columns :permissions, :permission_category_id, type: :integer
  end
end
