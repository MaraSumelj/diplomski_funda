class User < ActiveRecord::Base
	has_many :microposts, dependent: :destroy

	has_many :active_relationships, class_name: "Relationship",
			  foreign_key: "follower_id", dependent: :destroy

	has_many :following, through: :active_relationships, source: :followed

	attr_accessor :remember_token
	before_save { self.email = email.downcase }
	validates :name, presence: {message: 'ne smije biti prazno'}, length: { maximum: 50, message: 'je predugo'}
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, presence: {message: 'ne smije biti prazan'}, length: { maximum: 255, message: 'je predug'},
		format: { with: VALID_EMAIL_REGEX, message: 'nije ispravan'},
		uniqueness: { case_sensitive: false, message: 'već postoji'}
	
	has_secure_password

	# Returns the hash digest of the given string.
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
		BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end
	# Returns a random token.
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# Remembers a user in the database for use in persistent sessions.
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# Returns true if the given token matches the digest.
	def authenticated?(remember_token)
		return false if remember_digest.nil?
		BCrypt::Password.new(remember_digest).is_password?(remember_token)
	end

	# Forgets a user.
	def forget
		update_attribute(:remember_digest, nil)
	end

	# Follows a page.
	def follow(page)
		active_relationships.create(followed_id: page.id)
	end
	# Unfollows a page.
	def unfollow(page)
		active_relationships.find_by(followed_id: page.id).destroy
	end
	# Returns true if the current user is following the page.
	def following?(page)
		following.include?(page)
	end

	# Returns a user's status feed.
	def feed
		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
		Micropost.where("page_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
	end
 
 	def feed_for_specific_user(id_current_user)
 		following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :id_current_user"
 		Micropost.where("page_id IN (#{following_ids}) AND user_id = :user_id", user_id: id, id_current_user: id_current_user)
 	end
end
