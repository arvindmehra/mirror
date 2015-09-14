class AddFieldsToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :impact, :string
    add_column :notes, :feeling, :string
    add_column :notes, :impact_score, :integer
    add_column :notes, :feeling_score, :integer
  end
end
