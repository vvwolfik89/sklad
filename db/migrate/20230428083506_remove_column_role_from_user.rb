class RemoveColumnRoleFromUser < ActiveRecord::Migration[7.0]
  def change
    remove_columns :users, :role, type: :integer
  end
end
