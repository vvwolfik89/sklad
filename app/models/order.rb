class Order < ApplicationRecord
  # belongs_to :order_detail
  has_and_belongs_to_many :product_types
end
