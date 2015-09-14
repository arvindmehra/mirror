class InvertForeignKeyOnLocations < ActiveRecord::Migration
  def change
    remove_column :notes, :location_id
    add_column :locations, :note_id, :integer, index: true
  end
end
