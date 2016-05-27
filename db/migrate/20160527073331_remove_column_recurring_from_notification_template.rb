class RemoveColumnRecurringFromNotificationTemplate < ActiveRecord::Migration
  def change
    remove_column :notification_templates, :recurring
  end
end
