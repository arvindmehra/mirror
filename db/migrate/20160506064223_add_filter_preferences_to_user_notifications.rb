class AddFilterPreferencesToUserNotifications < ActiveRecord::Migration
  def change
    add_column :user_notifications, :filter_preferences, :text, after: :mark_deleted
  end
end
