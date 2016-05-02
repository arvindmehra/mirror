class AddColumnToNotificationTemplates < ActiveRecord::Migration
  def change
    add_column :notification_templates, :display_screen, :string, after: :category
    add_column :notification_templates, :cta_key, :string, after: :cta
  end
end
