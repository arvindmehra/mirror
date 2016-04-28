class CreateNotificationTemplates < ActiveRecord::Migration
  def change
    create_table :notification_templates do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :merge_field
      t.string :cta
      t.boolean :useful
      t.belongs_to :rule_engine
      t.string :execution_type
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active
      t.timestamps
    end
  end
end
