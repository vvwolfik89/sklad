class OrderDetail < ApplicationRecord
  belongs_to :partner
  belongs_to :order_log
  has_many :orders, dependent: :destroy
  accepts_nested_attributes_for :orders, allow_destroy: true
end
