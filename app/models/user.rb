class User < ActiveRecord::Base
	attr_accessible :email, :password_digest
	has_secure_password
	
	before_save { self.email.downcase! }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email,		presence: true,
								format: { with: VALID_EMAIL_REGEX }
								uniqueness: { case_sensitive: false }
	
	validates :password,	length: { minimum: 6 }
end