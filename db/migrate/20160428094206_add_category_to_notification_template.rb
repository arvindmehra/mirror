class AddCategoryToNotificationTemplate < ActiveRecord::Migration
  def change
    add_column :notification_templates, :category, :string, after: :execution_type
  end
end
