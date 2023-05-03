class Permission < ApplicationRecord
  # belongs_to :permission_category
  has_and_belongs_to_many :roles

  validates :name, :action_name, :class_name, presence: true

  after_save :touch_roles
  before_destroy :touch_roles

  # has_paper_trail

  private

  # used to update cached permission list
  def touch_roles
    roles.update_all(updated_at: Time.current)
  end
end
