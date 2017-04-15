class CreateUserWords < ActiveRecord::Migration[5.0]
  def change
    create_table :user_words do |t|
      t.string :transcription
      t.string :translation
      t.text :associate
      t.text :phrase
      t.string :url
      t.boolean :share
      t.boolean :learned
      t.integer :user_id
      t.integer :word_id

      t.timestamps
    end
  end
end
