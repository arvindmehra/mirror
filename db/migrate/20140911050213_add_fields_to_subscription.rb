class AddFieldsToSubscription < ActiveRecord::Migration
  def change
    add_column :subscriptions, :store, :string
    add_column :subscriptions, :transaction_id, :string
    add_column :subscriptions, :transaction_kind, :string
    add_column :subscriptions, :currency, :string
    add_column :subscriptions, :price, :decimal, :precision => 8, :scale => 2
  end
end
