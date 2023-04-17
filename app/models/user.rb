class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  enum role: [:user, :moderator, :admin]
  after_initialize :set_default_role, :if => :new_record?

  has_one_attached :avatar


  def full_name
    "#{self.last_name} #{self.first_name} #{self.patronymic}"
  end

  def set_default_role
    self.role ||= :user
  end
end
