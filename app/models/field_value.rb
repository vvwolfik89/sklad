class FieldValue < ApplicationRecord
  belongs_to :entry
  belongs_to :field, dependent: :destroy

  # Для текстовых/числовых полей
  attribute :value, :text

  # Для полей‑ссылок (user_select, car_select)
  attribute :related_record_id, :integer

  # validates :value, presence: true, if: -> { field.required? }

end
