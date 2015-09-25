class AddImageToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :original_image_path, :string, :limit => 500
    add_column :notes, :thumb_image_path, :string, :limit => 500
  end
end
