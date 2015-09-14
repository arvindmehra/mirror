class RenameTransactionFields < ActiveRecord::Migration
  def change
    rename_column :transactions, :transaction_id, :receipt
    rename_column :transactions, :transaction_kind, :kind
  end
end
