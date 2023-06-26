class Register < ApplicationRecord
  validates :name, :department_id, :user_id, :type, presence: true
  has_one :user
  has_one :car

end
