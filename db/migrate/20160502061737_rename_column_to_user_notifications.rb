class RenameColumnToUserNotifications < ActiveRecord::Migration
  def change
    rename_column :user_notifications, :admin_notification_id, :notification_template_id
  end
end
