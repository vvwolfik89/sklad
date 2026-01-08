module Availability
  extend ActiveSupport::Concern

  included do
    helper_method :available_partners# :available_campaigns, :available_call_centers, :available_teams,
                  # :available_agents, :available_lead_dispositions, :available_clients, :available_roles,
                  # :available_scripts, :available_score_card_settings,
                  # :available_downsell_dispositions, :available_score_card_groups,
                  # :available_script_contents, :available_yodel_customers, :available_yodel_customer_campaign_settings,
                  # :available_score_card_review_settings, :agent_notifications, :available_dynamic_drivers,
                  # :available_matching_data_providers, :available_score_card_review_groups, :available_yodel_companies,
                  # :available_dynamic_driver_data_adapters, :available_campaign_yodel_customer_entries, :available_client_yodel_customer_entries,
                  # :available_score_card_auto_rejection_settings
  end

  protected

  def available_partners
    @available_partners ||= Partner.all
  end

  # def available_campaigns
  #   @available_campaigns ||= Campaign.get_campaigns_by_user(current_agent)
  # end
  #
  # def available_call_centers
  #   @available_call_centers ||= CallCenter.get_call_centers_by_user(current_agent)
  # end
  #
  # def available_teams
  #   @available_teams ||= Team.get_teams_by_user(current_agent)
  # end
  #
  # def available_agents
  #   @available_agents ||= Agent.get_agents_by_user(current_agent)
  # end
  #
  # def available_lead_dispositions
  #   @available_lead_dispositions ||= LeadDisposition.available_for(current_agent).order(:description)
  # end
  #
  # def available_downsell_dispositions
  #   @available_downsell_dispositions ||= DownsellDisposition.get_downsell_dispositions_by_user(current_agent)
  # end
  #
  # def available_roles
  #   @available_roles ||= Role.available_for(current_agent)
  # end
  #
  # def available_score_card_groups
  #   @available_score_card_groups ||= ScoreCards::ScoreCardGroup.available_for(current_agent)
  # end
  #
  # def available_clients
  #   @available_clients ||= Client.get_clients_by_user(current_agent)
  # end
  #
  # def available_scripts
  #   @available_scripts ||= Script.permitted_for(current_agent)
  # end
  #
  # def available_script_contents
  #   @available_script_contents ||= ScriptContent.get_script_contents_by_scripts(available_scripts)
  # end
  #
  # def available_score_card_settings
  #   @available_score_card_settings ||= ScoreCards::ScoreCardSetting.available_for(current_agent)
  # end
  #
  # def available_score_card_review_settings
  #   @available_score_card_review_settings ||= ScoreCardsReview::ScoreCardReviewSetting.available_for(current_agent)
  # end
  #
  # def available_yodel_customers
  #   @available_yodel_customers ||= YodelCustomer.all
  # end
  #
  # def available_yodel_customer_campaign_settings
  #   @available_yodel_customer_campaign_settings ||= YodelCustomerCampaignSetting.all
  # end
  #
  # def agent_notifications
  #   @agent_notifications ||= current_agent.agent_notifications
  # end
  #
  # def available_dynamic_drivers
  #   @available_dynamic_drivers ||= DynamicDriver.order(name: :asc)
  # end
  #
  # def available_matching_data_providers
  #   @available_matching_data_providers ||= MatchingPortals::DataProvider.order(name: :asc)
  # end
  #
  # def available_score_card_review_groups
  #   @available_score_card_review_groups ||= ScoreCardsReview::ScoreCardReviewGroup.order('name')
  # end
  #
  # def available_yodel_companies
  #   @available_yodel_companies ||= YodelCompany.order('name')
  # end
  #
  # def available_dynamic_driver_data_adapters
  #   @available_dynamic_driver_data_adapters ||= DynamicDriverDataAdapter.order('name')
  # end
  #
  # def available_campaign_yodel_customer_entries
  #   @available_campaign_yodel_customer_entries ||= YodelCustomerEntries::CampaignYodelCustomerEntry.where(resource_id: available_campaigns.pluck(:id))
  # end
  #
  # def available_client_yodel_customer_entries
  #   @available_client_yodel_customer_entries ||= YodelCustomerEntries::ClientYodelCustomerEntry.where(resource_id: available_clients.pluck(:id))
  # end
  #
  # def available_score_card_auto_rejection_settings
  #   @available_score_card_auto_rejection_settings ||= ScoreCards::ScoreCardAutoRejectionSetting.all
  # end
end
