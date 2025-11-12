class OrderDetails < ApplicationRecord
  belongs_to :partners
  belongs_to :order_logs
  has_many :orders
end
