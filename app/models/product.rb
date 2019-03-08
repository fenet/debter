class Product < ApplicationRecord
	before_create :randomize_id

	##assocations
	belongs_to :catagory
	has_many :tags
  has_many :product_items, dependent: :destroy
  has_many :sales, through: :product_items, dependent: :destroy
  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true
	## validation

	validates :product_name , :presence => true,
                          :length => { :maximum =>  50}
  validates :unit_price , :presence => true                    
	validates :quantity,  :presence => true
  validates :created_by,  :presence => true
  validates :catagory_id,  :presence => true

  #mounting uploader
  
  mount_uploader :photo, PhotoUploader


  ## scope

    scope :recently_added, lambda { where('created_at >= ?', 1.week.ago)}
    scope :total_stock, lambda { order("created_at DESC")}

  private
  def randomize_id
    begin
      self.id = SecureRandom.random_number(1_000_000)
    end while Product.where(id: self.id).exists?
  end
end
