class AddShowUsefulToNotificationTemplate < ActiveRecord::Migration
  def change
    add_column :notification_templates, :show_useful, :boolean, after: :secondary_cta_key
    add_column :user_notifications, :show_useful, :boolean, after: :read_status
  end
end
