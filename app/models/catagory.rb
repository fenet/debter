class Catagory < ApplicationRecord
	##assocations

	has_many :products, through: :product_catagories
end
