class OrderLog < ApplicationRecord

  has_many :order_details, dependent: :destroy
  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :date, presence: true , uniqueness: { message: 'Дата должна присутствовать и уникальна' }
  # validates :order_details, presence: true
  validates_associated :order_details, presence: true
  validate :unique_partner_ids_in_order_details

  private

  def unique_partner_ids_in_order_details
    # 1. Получаем активные детали (не помеченные на удаление)
    active_details = order_details.reject(&:marked_for_destruction?)

    # 2. Если активных нет — валидация не нужна
    return if active_details.empty?

    # 3. Собираем partner_id активных записей
    partner_ids = active_details.map(&:partner_id).compact

    # 4. Проверяем уникальность
    if partner_ids.size != partner_ids.uniq.size
      # Находим дубликаты
      duplicates = partner_ids.group_by(&:itself)
                              .select { |k, v| v.size > 1 }
                              .keys
      errors.add(
        :order_details,
        "содержат дублирующиеся partner_id: #{duplicates.join(', ')}"
      )
    end
  end


end
