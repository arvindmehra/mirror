class CreatePushNotifications < ActiveRecord::Migration
  def change
    create_table :push_notifications do |t|
    	t.string :environment
    	t.text :ios_certificate

      t.timestamps
    end
  end
end
