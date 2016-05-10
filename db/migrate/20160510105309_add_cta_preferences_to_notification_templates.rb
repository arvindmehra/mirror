class AddCtaPreferencesToNotificationTemplates < ActiveRecord::Migration
  def change
    add_column :notification_templates, :cta_preferences, :text, after: :filter_preferences
  end
end
