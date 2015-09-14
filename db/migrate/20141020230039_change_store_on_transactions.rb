class ChangeStoreOnTransactions < ActiveRecord::Migration
  def change
    rename_column :transactions, :store, :platform
  end
end
