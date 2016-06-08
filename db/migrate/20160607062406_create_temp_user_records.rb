class CreateTempUserRecords < ActiveRecord::Migration
  def change
    create_table :temp_user_records do |t|
    	t.integer :user_id
    	t.integer :goal
    	t.float :time_spent
    	t.date :activity_date
    end
  end
end