class ChangeDescriptionTypeInUserNotification < ActiveRecord::Migration
  def change
   change_column :user_notifications, :description, :text
  end
end
