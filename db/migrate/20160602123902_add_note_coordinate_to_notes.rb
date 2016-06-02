class AddNoteCoordinateToNotes < ActiveRecord::Migration
  def change
  	add_column :notes, :note_coordinate, :string
  end
end
