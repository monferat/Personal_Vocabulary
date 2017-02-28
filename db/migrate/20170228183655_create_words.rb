class CreateWords < ActiveRecord::Migration[5.0]
  def change
    create_table :words do |t|
      t.string :name
      t.string :transcription
      t.string :translation
      t.text :association
      t.text :phrase
      t.string :url
      t.string :share
      t.boolean :learned
      t.integer :user_id
      t.integer :theme_id

      t.timestamps
    end
  end
end
