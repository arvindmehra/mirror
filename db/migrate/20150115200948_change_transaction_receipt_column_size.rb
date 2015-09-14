class ChangeTransactionReceiptColumnSize < ActiveRecord::Migration
  def change
    change_column :transactions, :receipt, :text, :limit => 4294967295
  end
end