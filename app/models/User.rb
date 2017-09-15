class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  attr_accessor :remember_token, :reset_token
  before_save :downcase_email
  before_save :downcase_username
  mount_uploader :picture, UserUploader

  # Amount of users shown per page with pagination
  self.per_page = 20
  

  #VALIDATIONS
  #Email
  VALID_EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]/i
  validates :email, presence: true, length: {maximum: 200}, format: { with:  VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #Name
  validates :name, presence: true, length: {maximum: 50}
  #Username
  VALID_USERNAME_REGEX = /\A[a-z0-9][_a-z0-9]{1,30}\Z/i
  validates :username, presence: true, length: {maximum: 30}, format: {with: VALID_USERNAME_REGEX, message: "must start with a letter or number. It can only contain characters (a-z), (1-9) or underscore '_' "}, uniqueness: { case_sensitive: false }
  #Password
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  #Profile Image
  validate  :picture_size

  #CLASS METHODS
  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token()
    SecureRandom.urlsafe_base64
  end

  #INSTANCE METHODS
  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token()
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil? 
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Sets the password reset attributes.
  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest:  User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Returns a user's status feed.
  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE  follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

  # Follows a user.
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # Unfollows a user.
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end

private

  # Downcase email before being saved
  def downcase_email
    self.email = email.downcase
  end

  # Downcase username before being saved
  def downcase_username
    self.username = username.downcase
  end

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 2.megabytes
      errors.add(:base, "Please select a smaller file size image")
    end
  end

end
