class Field < ApplicationRecord
  belongs_to :journal
  has_many :field_values, dependent: :destroy

  validates :name, presence: true

  # validates :field_type, inclusion: { in: %w[text date boolean] }

  # Типы полей: text, date, boolean, time, user_select, car_select и др.
  enum field_type: {
    text: 'text',
    date: 'date',
    boolean: 'boolean',
    time: 'time',
    user_select: 'user_select',
    car_select: 'car_select',
    dropdown: 'select'
  }

  attribute :related_model, :string      # 'User', 'Car'
  attribute :display_field, :string     # 'full_name', 'license_plate'
  attribute :options, :json           # для type=select (массив вариантов)


  def self.field_type_options
    field_types.map do |key, value |
      [I18n.t("activerecord.attributes.field.field_type.#{key}"), value]  # humanize превращает :text → "Text"
    end
  end

  # Возвращает все записи связанной модели (User, Car и т.д.)
  def related_records
    return [] unless related_model
    related_model.constantize.all
  end

  # Массив опций для select-поля
  def options_array
    options.split(/\s*,\s*/).map(&:to_i) || []
  end
end
