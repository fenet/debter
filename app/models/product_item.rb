class ProductItem < ApplicationRecord
	##asscoation
	belongs_to :product

	belongs_to :sale

	before_destroy :reset_product_quantity

	## validation
	                   
		validates :selling_price,  :presence => true
	  validates :quantity,  :presence => true

	private

	def reset_product_quantity
    quantity = product.quantity + self.quantity
    product.update_columns(quantity: quantity)
  end

end
