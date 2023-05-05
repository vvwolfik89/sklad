class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # enum roles: [:user, :moderator, :admin]
  # after_initialize :set_default_role, :if => :new_record?

  has_one_attached :avatar

  has_and_belongs_to_many :departments
  has_and_belongs_to_many :roles

  validate :one_department_is_selected

  def full_name
    "#{self.last_name} #{self.first_name} #{self.patronymic}"
  end

  def set_default_role
    self.role ||= :user
  end

  def self.gender_attributes_for_select
    roles.map do |role, _|
      [I18n.t("activerecord.attributes.#{model_name.i18n_key}.roles.#{role}"), role]
    end
  end

  private

  def one_department_is_selected
    unless (self.departments.size > 0)
      errors.add(:departments, "You must select a department")
    end
  end


end
