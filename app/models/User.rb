class User < ActiveRecord::Base
  attr_accessor :remember_token

  #VALIDATIONS
	#Email
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]/i
  validates :email, presence: true, length: {maximum: 200}, format: { with:  VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #Name
  validates :name, presence: true, length: {maximum: 50}
  #Password
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true

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
  def authenticated?(remember_token)
    self.remember_digest.nil? ? false : BCrypt::Password.new(self.remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end
end
