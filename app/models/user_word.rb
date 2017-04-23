class UserWord < ApplicationRecord
  include Filterable

  belongs_to :user
  belongs_to :word

  has_attached_file :image, default_url: 'missing.png'
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/

  scope :recent, -> { order(:created_at).reverse }
  scope :shared, -> (shared){ where share: shared }
  scope :learn, -> (learn){ where learned: learn }
  scope :category, -> (category_name){ joins(word: :theme).where('themes.name = ?', category_name) }

end
