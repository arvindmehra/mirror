class AddScheduledTimeToNotificationTemplate < ActiveRecord::Migration
  def change
    add_column :notification_templates, :scheduled_time, :datetime, after: :active
    add_column :notification_templates, :recurring, :boolean, after: :active
  end
end
