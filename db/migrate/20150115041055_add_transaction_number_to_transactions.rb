class AddTransactionNumberToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :transaction_number, :integer
  end
end
