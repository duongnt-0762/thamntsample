class User < ApplicationRecord
	has_many :microposts, dependent: :destroy
	attr_accessor :remember_token
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

	def feed
		Micropost.where("user_id = ?", id)
	end

	private
	
		def downcase_email
		  self.email = email.downcase 
		end		  
end


class Micropost < ApplicationRecord
	belongs_to :user
	has_one_attached :image
	default_scope -> { order(created_at: :desc) }
	validates :user_id, presence: true
	validates :content, presence: true, length: { maximum: 140 }
	validates :image, content_type: { in: %w[image/jpeg image/gif image/png],
									  message: "must be a valid image format" },
					  size: { less_than: 5.megabytes,
							  message: "should be less than 5MB" }
	# Returns a resized image for display.
	def display_image
		image.variant(resize_to_limit: [500, 500])
	end
end