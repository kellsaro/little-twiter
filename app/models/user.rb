class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token
  # Adds 'password' and 'password_confirmation' virtual attibutes
  has_secure_password
  has_many :microposts, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship',
	                          foreign_key: 'follower_id',
				  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :pasive_relationships, class_name: 'Relationship',
	                          foreign_key: 'followed_id',
				  dependent: :destroy
  has_many :followers, through: :pasive_relationships, source: :follower


  before_save :downcase_email
  before_create :create_activation_digest
  	
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
	    format: {with: VALID_EMAIL_REGEX },
	    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: {minimum: 6}, allow_nil: true

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST 
                                                : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)	
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = SecureRandom.urlsafe_base64
    update_attribute(:remember_digest, User.digest(self.remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return BCrypt::Password.new(digest).is_password?(token)
  rescue BCrypt::Errors::InvalidHash
    return false
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = SecureRandom.urlsafe_base64
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
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

  # Returns a user's status feed.
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"

    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  private
    # Converts email to all lower-case.
    def downcase_email
      self.email.downcase!
    end

    # Creates and assigns the activation token and digest.
    def create_activation_digest
      self.activation_token = SecureRandom.urlsafe_base64
      self.activation_digest = User.digest(activation_token)
    end
end
