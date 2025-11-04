class CreateJoinTableOrderLogsPartners < ActiveRecord::Migration[7.0]
  def change
    create_join_table :order_logs, :partners do |t|
      t.index [:order_log_id, :partner_id]
      t.index [:partner_id, :order_log_id]
    end

    # create_join_table(:clients, :score_card_auto_rejection_settings, table_name: :filter_clients_auto_rejection_settings) do |t|
    #   t.index :client_id, name: 'index_filter_clients_auto_rejection_settings_client_id'
    #   t.index :score_card_auto_rejection_setting_id, name: 'index_filter_clients_auto_rejection_settings_scars_id'
    # end


  end
end
