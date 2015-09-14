class FixLocationTable < ActiveRecord::Migration
  def change
    remove_column :locations, :name
    add_column :locations, :country, :string
    add_column :locations, :city, :string
  end
end
