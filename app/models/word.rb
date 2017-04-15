class Word < ApplicationRecord
  belongs_to :theme
  has_many :user_words
end
