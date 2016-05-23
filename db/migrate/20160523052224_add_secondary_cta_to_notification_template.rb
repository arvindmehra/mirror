class AddSecondaryCtaToNotificationTemplate < ActiveRecord::Migration
  def change
  	add_column :notification_templates, :secondary_cta, :string, after: :cta_key
  	add_column :notification_templates, :secondary_cta_key, :string, after: :secondary_cta
  end
end
