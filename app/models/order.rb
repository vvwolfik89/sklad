class Order < ApplicationRecord
  has_paper_trail ignore: [:updated_at]
  # belongs_to :order_detail
  has_and_belongs_to_many :product_types
  accepts_nested_attributes_for :product_types

  def product_type_names
    self.product_types.map {|product_type| product_type.name } if self.product_types
  end
end
