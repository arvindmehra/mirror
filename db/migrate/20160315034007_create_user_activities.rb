class CreateUserActivities < ActiveRecord::Migration
  def change
    create_table :user_activities do |t|
      t.belongs_to :user, index: true
      t.string :activity_date
      t.integer :time_spent
      t.timestamps
    end
  end
end
