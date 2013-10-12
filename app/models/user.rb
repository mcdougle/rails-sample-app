class User < ActiveRecord::Base
	attr_accessible :email, :password, :password_confirmation
	has_secure_password
	
	before_save { self.email.downcase! }
	before_create :create_remember_token
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email,		presence: true,
								format: { with: VALID_EMAIL_REGEX },
								uniqueness: { case_sensitive: false }
	
	validates :password,	length: { minimum: 6 }
	
	### SIGN-IN STUFF ###
	 # create a new :remember_token to handle sessions
	 	# static method returns random string
	def User.new_remember_token
		SecureRandom.urlsafe_base64			# returns a random base64 string
	end
	
	 # encrypt the :remember_token to store in db
	 	# static method returns encrypted token
	def User.encrypt (token)
		Digest::SHA1.hexdigest(token.to_s)
	end
	
	private
		 
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
