class RenameTransactionsStartTimeToOrigPurchaseTime < ActiveRecord::Migration
  def change
    rename_column :transactions, :start_date, :orig_purchase_time
  end
end
