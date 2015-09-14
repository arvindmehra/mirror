class AddPlatformToReceipt < ActiveRecord::Migration
  def change
    add_column :receipts, :platform, :string
  end
end
