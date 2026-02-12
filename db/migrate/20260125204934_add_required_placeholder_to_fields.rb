class AddRequiredPlaceholderToFields < ActiveRecord::Migration[7.0]
  def change
    add_column :fields, :required, :boolean
    add_column :fields, :placeholder, :text
  end
end
