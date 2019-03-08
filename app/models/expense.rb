class Expense < ApplicationRecord

	## validation
                     
    validates :expense,  :presence => true

	## scope

    scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
end
