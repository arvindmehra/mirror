class AddNotificationTokenToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :notification_token, :string
  end
end
