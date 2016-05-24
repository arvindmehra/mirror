class AddSecondaryCtaToUserNotifications < ActiveRecord::Migration
  def change
    add_column :user_notifications, :secondary_cta, :string, after: :cta_key
    add_column :user_notifications, :secondary_cta_key, :string, after: :secondary_cta
  end
end
