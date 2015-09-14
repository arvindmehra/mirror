class RemoveReceiptIdFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :receipt_id, :string
  end
end
