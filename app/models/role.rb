class Role < ApplicationRecord
  # include PublicActivity::Model
  # include ScopedSetting

  # scoped_field :import_lead_customer_duration_limit, default: 90
  enum role_type: [:super_admin, :company_admin, :department_admin, :department_admin_second, :driver, :cleaner, :picker, :loader]

  validates :role_type, :title, presence: true

  has_and_belongs_to_many :users
  has_and_belongs_to_many :permissions

  # before_destroy :check_for_types

  # scope :available_for, -> (agent) {
  #   if agent.is_superadmin
  #     all
  #   else
  #     joins(:parent_allowed_roles).where(allowed_roles: {role_id: agent.role_ids}).distinct
  #   end.order(:title)
  # }


  def self.role_type_attributes_for_select
    role_types.map do |role, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.role_types.#{role}"), role]
    end
  end

  private



  # def check_for_types
  #   if any_role_type_selected?
  #     errors[:base] << 'Role Type is currently selected, in order to delete, there can\'t be a Role Type selected.'
  #     throw :abort
  #   end
  # end
  #
  # def any_role_type_selected?
  #   Role::USERS_TYPES.inject(false) { |n, type| self[type] || n }
  # end
end
