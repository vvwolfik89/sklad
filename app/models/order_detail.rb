class OrderDetail < ApplicationRecord
  belongs_to :partner
  belongs_to :order_log

  validates :partner_id, presence: true
  # has_many :orders, dependent: :destroy
  # accepts_nested_attributes_for :orders, allow_destroy: true

  def marked_for_destruction?
    # Rails устанавливает @marked_for_destruction при передаче _destroy
    @marked_for_destruction == true
  end
end
