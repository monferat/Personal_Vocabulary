class UserWord < ApplicationRecord
  belongs_to :user
  belongs_to :word

  has_attached_file :image, default_url: 'missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
end