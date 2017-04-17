class Theme < ApplicationRecord
  has_many :words

  validates :name, presence: true, length: { maximum: 50 },
            uniqueness: { case_sensitive: false }

end
