class Product < ApplicationRecord
	before_create :randomize_id

	##assocations
	belongs_to :catagory
	has_many :tags
  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true
	## validation

	validates :product_name , :presence => true,
                          :length => { :maximum =>  50}
  validates :unit_price , :presence => true                    
	validates :quanity,  :presence => true
  validates :created_by,  :presence => true
  validates :catagory_id,  :presence => true

  #mounting uploader
  
  mount_uploader :photo, PhotoUploader

  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000)
    end while Product.where(id: self.id).exists?
  end
end
