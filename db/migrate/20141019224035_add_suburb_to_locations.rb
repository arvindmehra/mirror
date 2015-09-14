class AddSuburbToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :suburb, :string
  end
end
