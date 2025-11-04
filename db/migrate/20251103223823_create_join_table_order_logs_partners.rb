class CreateJoinTableOrderLogsPartners < ActiveRecord::Migration[7.0]
  def change
    create_join_table :order_logs, :partners do |t|
      t.index :order_log_id
      t.index :partner_id
    end
  end
end
