class OrderLog < ApplicationRecord
  include TrackableLastChanger
  has_paper_trail ignore: [:updated_at]

  has_many :order_details, dependent: :destroy
  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :date, presence: true , uniqueness: { message: 'Дата должна присутствовать и уникальна' }
  # validates :order_details, presence: true
  validates_associated :order_details, presence: true
  validate :unique_partner_ids_in_order_details

  scope :by_date, -> (date) { where(date: date) if date.present? }
  scope :with_all_partners, -> (partner_ids) {
    return all unless partner_ids.present? && partner_ids.any?

    joins(order_details: :partner)
      .where(order_details: { partner_id: partner_ids })
      .group(:id)
      .having("COUNT(DISTINCT order_details.partner_id) = ?", partner_ids.size)
  }
  scope :with_product_types, -> (product_type_ids) {
    return all unless product_type_ids.present? && product_type_ids.any?

    # Удаляем дубликаты
    unique_ids = product_type_ids.uniq

    joins(order_details: { orders: :product_types })
      .where(product_types: { id: unique_ids })
      .group(:id)
      .having("COUNT(DISTINCT product_types.id) = ?", unique_ids.size)
  }
  def related_versions
    # Собираем версии всех связанных записей
    versions = self.versions
    order_details.each do |detail|
      versions += detail.versions
      detail.orders.each do |order|
        versions += order.versions
      end
    end
    versions.sort_by(&:created_at)
  end

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
