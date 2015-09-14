class RemoveLocationTableAndMoveToNotes < ActiveRecord::Migration
  def change
    drop_table :locations
    add_column :notes, :address, :string
    add_column :notes, :city, :string
    add_column :notes, :suburb, :string
    add_column :notes, :country, :string
    add_column :notes, :latitude, :float
    add_column :notes, :longitude, :float
  end
end
