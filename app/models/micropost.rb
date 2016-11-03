class Micropost < ActiveRecord::Base
  belongs_to :user
  belongs_to :page
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :page_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # Tells rails to use this uploader for this model.
  mount_uploader :attachment, AttachmentUploader 
end
