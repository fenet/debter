class Product < ApplicationRecord
	##assocations
	has_many :product_catagories
  has_many :catagories, through: :product_catagories
  accepts_nested_attributes_for :catagories, reject_if: :all_blank, allow_destroy: true
end
