class AddColumnRecurringEveryToNotificationTemplate < ActiveRecord::Migration
  def change
  	add_column :notification_templates, :recurring_every, :string, after: :active
  end
end
