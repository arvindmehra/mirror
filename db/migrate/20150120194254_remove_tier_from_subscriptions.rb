class RemoveTierFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :tier_id
  end
end
