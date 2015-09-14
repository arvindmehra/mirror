class RemoveProductIdFromTransactions < ActiveRecord::Migration
  def change
    remove_column :transactions, :product_id
    add_column :transactions, :bundle_name, :string, index: true
  end
end
