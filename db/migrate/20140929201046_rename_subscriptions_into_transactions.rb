class RenameSubscriptionsIntoTransactions < ActiveRecord::Migration
  def change
    rename_table :subscriptions, :transactions
  end
end
