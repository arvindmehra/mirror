class AddColumnProcuctToNt < ActiveRecord::Migration
  def change
    add_column :notification_templates, :product, :string
  end
end
