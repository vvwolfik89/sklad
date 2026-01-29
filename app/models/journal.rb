class Journal < ApplicationRecord
  has_many :fields, dependent: :destroy
  has_many :entries, dependent: :destroy
  has_many :schedules, dependent: :destroy

  validates :title, presence: true

  accepts_nested_attributes_for :fields,
                                allow_destroy: true,          # разрешаем удаление полей
                                reject_if: proc { |attributes| attributes['name'].blank? }  # игнорируем пустые
end
