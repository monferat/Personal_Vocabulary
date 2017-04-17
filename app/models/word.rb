class Word < ApplicationRecord
  belongs_to :theme
  has_many :user_words

  validates :name, presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

end
