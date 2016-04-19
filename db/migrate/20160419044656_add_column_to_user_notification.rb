class AddColumnToUserNotification < ActiveRecord::Migration
  def change
    add_column :user_notifications, :cta_key, :string, after: :cta
    add_column :user_notifications, :display_screen, :string, after: :category
  end
end
