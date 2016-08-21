class User < ActiveRecord::Base
	#Email
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[a-z]+@[a-z]+\.[a-z]+\z/i
  validates :email, presence: true, length: {maximum: 200}, format: { with:  VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  #Name
  validates :name, presence: true, length: {maximum: 50}

  #Password
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

   # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
