class AdminUser < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :validatable, :trackable

  validates :full_name , :presence => true,
                          :length => { :maximum =>  25}
  # validates :company_name , :presence => true                    
	validates :role,  :presence => true
end
