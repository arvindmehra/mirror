class ChangeReceiptColumnForReceipt < ActiveRecord::Migration
  def change
    change_column :receipts, :receipt, :text, :limit => 4294967295
  end
end
