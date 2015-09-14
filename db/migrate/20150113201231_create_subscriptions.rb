class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :user_id
      t.datetime :start_date
      t.datetime :end_date
      t.integer :tier_id
      t.boolean :is_active

      t.timestamps
    end
  end
end
