class AddRecordedAtToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :recorded_at, :datetime
  end
end
