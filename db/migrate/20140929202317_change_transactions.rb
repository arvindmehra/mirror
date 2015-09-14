class ChangeTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :product_id, :integer, index: true
  end
end
