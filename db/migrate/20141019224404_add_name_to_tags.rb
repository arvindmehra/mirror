class AddNameToTags < ActiveRecord::Migration
  def change
    add_column :tags, :name, :string
    add_index :tags, :name
  end
end
