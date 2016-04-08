class CreateUserNotifications < ActiveRecord::Migration
  def change
    create_table :user_notifications do |t|
      t.string :title
      t.string :subtitle
      t.string :description
      t.string :merge_field
      t.belongs_to :user
      t.belongs_to :admin_notification
      t.string :cta
      t.string :category
      t.boolean :read_status
      t.boolean :useful
      t.boolean :mark_deleted
      t.datetime :sent_at

      t.timestamps
    end
  end
end
