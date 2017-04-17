class SetDefaultValuesForUserWord < ActiveRecord::Migration[5.0]
  def change
    change_column :user_words, :share, :boolean, default: false
    change_column :user_words, :learned, :boolean, default: false
  end
end
