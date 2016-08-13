class User < ActiveRecord::Base
  before_save { email.downcase! }
  has_secure_password
  VALID_EMAIL_REGEX = /\A[a-z]+@[a-z]+\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: 50}
  validates :email, presence: true, length: {maximum: 200}, format: { with:  VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }
end
