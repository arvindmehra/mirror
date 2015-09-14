class AddLoginCountFieldsToUsers < ActiveRecord::Migration
  
  def change
    add_column :users, :app_opens_count, :integer
    add_column :devices, :location_enabled, :boolean
  end
  
end
