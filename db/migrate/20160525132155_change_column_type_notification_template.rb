class ChangeColumnTypeNotificationTemplate < ActiveRecord::Migration
  def change
    change_column :notification_templates, :start_date, :date
    change_column :notification_templates, :end_date, :date
    change_column :notification_templates, :scheduled_time, :string
  end
end
