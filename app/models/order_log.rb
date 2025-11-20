class OrderLog < ApplicationRecord

  has_many :order_details, dependent: :destroy
  accepts_nested_attributes_for :order_details, allow_destroy: true

  validates :date, presence: true , uniqueness: { message: 'Дата должна присутствовать и уникальна' }
  # validates :order_details, presence: true
  validates_associated :order_details, presence: true
  validate :unique_partner_ids_in_order_details

  # enum indicator_type: {
  #   all_submissions: 0,
  #   accepted_submissions: 1,
  #   all_submission_resources: 2,
  #   accepted_submission_resources: 3,
  #   form_field_range_levels: 4
  # }


  TYPE_ORDERS = {
    disp: 1,
    imn_bad: 2,
    hol2_8: 3,
    bad2_8: 4,
    hol8_15: 5,
    a: 6,
    lrs: 7,
    pac: 8
  }

  def type_orders=(type_orders)
    self[:type_orders] = (type_orders).map {|t| TYPE_ORDERS[t]}
  end

  def type_orders
    TYPE_ORDERS.keys.select {|t| self[:type_orders].to_i & TYPE_ORDERS[t] != 0}
  end

  def has_type_orders?(type_order)
  self[:type_orders].to_i & TYPE_ORDERS[type_order] != 0
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
