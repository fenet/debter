class Catagory < ApplicationRecord
	##assocations
	has_many :products

	## validation

	validates :name , :presence => true,
                          :length => { :maximum =>  25}
end
