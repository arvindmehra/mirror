class AddProductIdToTransactions < ActiveRecord::Migration
  def change
    add_column :transactions, :product_id, :integer
  end
end
