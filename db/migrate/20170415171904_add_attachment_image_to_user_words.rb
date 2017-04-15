class AddAttachmentImageToUserWords < ActiveRecord::Migration[5.0]
  def self.up
    change_table :user_words do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :user_words, :image
  end
end
