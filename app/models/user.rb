class User < ActiveRecord::Base
	attr_accessible :email, :password, :password_confirmation
	has_secure_password
	has_many :microposts, dependent: :destroy
	
	 ## followed_users -> my "followeds" -> people I'm following -> people I "have followed"
		##follower_id is the foreign key because I'M THE FOLLOWER.
	has_many :relationships, foreign_key: "follower_id", dependent: :destroy
	has_many :followed_users, through: :relationships, source: :followed
	 ## followers -> my followers -> people following me
		## followed_id is the foreign key because I'M THE ONE FOLLOWED
	has_many :reverse_relationships,	foreign_key: "followed_id", 
														class_name: "Relationship",
														dependent: :destroy
	has_many :followers, through: :reverse_relationships, source: :follower
	
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
	
	### FEED STUFF
	def feed
		Micropost.where('user_id = ?', id)		# could just use `microposts` to get current user's list
	end
	
	### RELATIONSHIP STUFF
	def follow! (other_user)
		relationships.create!(followed_id: other_user.id)
	end
	
	def unfollow! (other_user)
		relationships.where(followed_id: other_user.id).first.destroy
	end
	
	def following? (other_user)
		relationships.where(followed_id: other_user.id).first
	end
	
	private
		 
		def create_remember_token
			self.remember_token = User.encrypt(User.new_remember_token)
		end
end
