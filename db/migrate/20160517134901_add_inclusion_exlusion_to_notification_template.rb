class AddInclusionExlusionToNotificationTemplate < ActiveRecord::Migration
  def change
    add_column :notification_templates, :in_exclusion_segment, :string
    add_column :notification_templates, :in_exclusion_operator, :string
    add_column :notification_templates, :in_exclusion_condition, :string
    add_column :notification_templates, :in_exclusion_notification_id, :integer
  end
end
