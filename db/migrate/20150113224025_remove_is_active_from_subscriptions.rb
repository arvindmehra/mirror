class RemoveIsActiveFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :is_active, :boolean
  end
end
