class RemoveEndDateAndTierAndCurrencyAndKindAndPriceFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :end_date
    remove_column :transactions, :tier
    remove_column :transactions, :currency
    remove_column :transactions, :price
    remove_column :transactions, :kind
  end
end
