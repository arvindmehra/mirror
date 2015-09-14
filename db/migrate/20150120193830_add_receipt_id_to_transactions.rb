class AddReceiptIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :receipt_id, :integer
  end
end
