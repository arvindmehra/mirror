class AddUserFieldsToTempUserNotes < ActiveRecord::Migration
  def change
    add_column :temp_user_notes, :region, :string
    add_column :temp_user_notes, :language, :string
    add_column :temp_user_notes, :version_number, :float
    add_column :temp_user_notes, :version_number_updated_at, :datetime
    add_column :temp_user_notes, :time_zone, :string
  end
end