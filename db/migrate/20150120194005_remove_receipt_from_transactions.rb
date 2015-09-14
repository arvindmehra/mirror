class RemoveReceiptFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :receipt
  end
end
