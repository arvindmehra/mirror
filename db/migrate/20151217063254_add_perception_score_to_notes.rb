class AddPerceptionScoreToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :perception_score, :integer
  end
end
