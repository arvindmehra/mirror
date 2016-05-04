class AddColumnToNotificationTemplates < ActiveRecord::Migration
  def change
    add_column :notification_templates, :display_screen, :string, after: :category
    add_column :notification_templates, :cta_key, :string, after: :cta
    add_column :notification_templates, :condition_met, :string, after: :active
    add_column :notification_templates, :elapse_time, :string, after: :condition_met
  end
end
