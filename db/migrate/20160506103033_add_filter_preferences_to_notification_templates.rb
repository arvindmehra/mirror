class AddFilterPreferencesToNotificationTemplates < ActiveRecord::Migration
  def change
    add_column :notification_templates, :filter_preferences, :text, after: :condition_met
  end
end
