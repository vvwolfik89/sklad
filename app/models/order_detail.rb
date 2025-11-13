class OrderDetail < ApplicationRecord
  belongs_to :partner
  belongs_to :order_log
  has_many :orders
end
