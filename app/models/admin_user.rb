class AdminUser < ActiveRecord::Base
  include Rails.application.routes.url_helpers
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
#   #after_create :envia_reset_email
# 
#   def password_required?
#     new_record? ? false : super
#   end
#   
#   # def envia_reset_email
#   #   send_reset_password_instructions
#   # end
end