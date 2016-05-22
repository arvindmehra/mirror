class AddTimeZoneToUsers < ActiveRecord::Migration
  def change
  	add_column :users, :region, :string
  	add_column :users, :language, :string
  	add_column :users, :version_number, :float
  	add_column :users, :version_number_updated_at, :datetime
  	add_column :users, :time_zone, :string
  end
end
