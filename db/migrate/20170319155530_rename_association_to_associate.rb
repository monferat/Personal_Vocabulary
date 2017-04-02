class RenameAssociationToAssociate < ActiveRecord::Migration[5.0]
  def change
    rename_column :words, :association, :associate
  end
end
