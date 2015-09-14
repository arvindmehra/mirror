class ChangeTransactionNumberType < ActiveRecord::Migration
  def change
        change_column :transactions, :transaction_number, :text
  end
end
