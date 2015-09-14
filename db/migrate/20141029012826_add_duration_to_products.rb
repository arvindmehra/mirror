class AddDurationToProducts < ActiveRecord::Migration
  def change
    add_column :products, :duration_in_months, :integer
  end
end
