class RenameConditionMetInNotificationTemplates < ActiveRecord::Migration
  def change
    rename_column :notification_templates, :condition_met, :trigger
  end
end
