class UserWord < ApplicationRecord
  include Filterable
  include PgSearch

  belongs_to :user
  belongs_to :word

  has_attached_file :image, default_url: 'missing.png'
  # validates_attachment_content_type :image, content_type: /\Aimage\/.*\z/
  do_not_validate_attachment_file_type :image

  scope :recent, -> { order(:created_at).reverse }
  scope :shared, -> (shared){ where share: shared }
  scope :learn, -> (learn){ where learned: learn }
  scope :category, -> (category_name){ joins(word: :theme).where('themes.name = ?', category_name) }

  pg_search_scope :search_by_transcription, :against => :transcription
  pg_search_scope :search_by_translation,
                  :against => :translation,
                  :using => {
                      :tsearch => {:prefix => true}
                  }
  pg_search_scope :search_by_word,
                  :associated_against => { :word => :name },
                  :using => {
                      :tsearch => {:prefix => true}
                  }

end
