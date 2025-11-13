class OrderLog < ApplicationRecord
  validates :date, presence: true , uniqueness: true

  has_many :order_details, dependent: :destroy
  accepts_nested_attributes_for :order_details
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


end
