class RemovePlatformFromTransaction < ActiveRecord::Migration
  def change
    remove_column :transactions, :platform
  end
end
