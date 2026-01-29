class Entry < ApplicationRecord
  belongs_to :journal
  belongs_to :creator, class_name: 'User'  # кто заполнил
  has_many :field_values, dependent: :destroy

  accepts_nested_attributes_for :field_values, reject_if: :all_blank, allow_destroy: true

  validates :date, presence: true
end
