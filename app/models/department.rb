class Department < ApplicationRecord
  validates :title, presence: true
end
