class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_activity, :datetime
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
  end
end
