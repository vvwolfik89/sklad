class OrderDetail < ApplicationRecord
  has_paper_trail ignore: [:updated_at]

  belongs_to :partner
  belongs_to :order_log

  validates :partner_id, presence: true
  # has_many :orders, dependent: :destroy
  # accepts_nested_attributes_for :orders, allow_destroy: true
  has_many :orders, dependent: :destroy
  accepts_nested_attributes_for :orders, allow_destroy: true

  validates_associated :orders, presence: true

  def get_all_product_type_names
    self.orders.map { |order| order.product_type_names }.flatten.uniq
  end
  def marked_for_destruction?
    # Rails устанавливает @marked_for_destruction при передаче _destroy
    @marked_for_destruction == true
  end
end
