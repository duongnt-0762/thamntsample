class User < ApplicationRecord
	attr_accessor :remember_token
	has_many :microposts, dependent: :destroy
	has_many :active_relationships, class_name: "Relationship",
									foreign_key: "follower_id",
									dependent: :destroy
	has_many :passive_relationships, class_name: "Relationship",
									foreign_key: "followed_id",
									dependent: :destroy								
	has_many :following, through: :active_relationships, source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	before_save :downcase_email
	validates :name, presence: true, length: { maximum: 50 }
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: true, length: { maximum: 255 },
							  format: { with: VALID_EMAIL_REGEX },
							  uniqueness: true
	has_secure_password
	validates :password, presence: true, allow_nil: true, length: { minimum: 6 }

	class << self
	# Returns the hash digest of the given string.
		def digest(string)
			cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
														  BCrypt::Engine.cost
			BCrypt::Password.create(string, cost: cost)
		end

		# Returns a random token.
		def new_token
			SecureRandom.urlsafe_base64
		end	
	end			

	# Remembers a user in the database for use in persistent sessions
	def remember
		self.remember_token = User.new_token
		update_attributes remember_digest: User.digest(remember_token)
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end			

	def forget
		update_attributes remember_digest: nil
	end	


	def current_user?(user)
		user && user == self
	end	

	# Returns true if a password reset has expired.
	def password_reset_expired?
		reset_sent_at < 2.hours.ago
	end	

	def feed
		part_of_feed = "relationships.follower_id = :id or microposts.user_id = :id"
		Micropost.joins(user: :followers).where(part_of_feed, { id: id })
	end

	# Follows a user.
	def follow(other_user)
		following << other_user
	end

	# Unfollows a user.
	def unfollow(other_user)
		following.delete(other_user)
	end

	# Returns true if the current user is following the other user.
	def following?(other_user)
		following.include?(other_user)
	end

	private


	def downcase_email
		def downcase_email
	  self.email = email.downcase 
		  self.email = email.downcase 	  
		end		  
	end
end


