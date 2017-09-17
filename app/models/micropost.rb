class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  mount_uploader :picture, MicropostUploader
  validates :user_id, presence: true
  validates :content, length: {maximum: 200}
  validate :picture_size
  validate :picture_content_present?

 # Amount of posts shown per page with pagination
  self.per_page = 10

private

  # Validates the size of an uploaded picture.
  def picture_size
    if picture.size > 5.megabytes
      errors.add(:picture, "should be less than 5MB")
    end
  end

  # This makes sure the user is posting atleast an image or content
  def picture_content_present?
    if !picture.present? && content.blank?
      errors.add :base, "Post must include an image or post"
    end
  end

end
