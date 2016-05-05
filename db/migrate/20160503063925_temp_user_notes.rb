class TempUserNotes < ActiveRecord::Migration
  def change
  	create_table :temp_user_notes do |t|
      t.integer :user_id
      t.string :encrypted_email
      t.string :last_activity
      t.string :activity_goal
      t.datetime :auth_token_created_at
      t.integer :notes_id
      t.string :category
      t.string :impact
      t.string :feeling
      t.integer :impact_score
      t.integer :feeling_score
      t.string :city
      t.string :suburb
      t.string :country
      t.float :heart_rate
      t.float :sleep_time
      t.float :temperature
      t.string :whether_type
      t.float :steps_walked
      t.float :calories_burnt
      t.float :perception_score
      t.datetime :notes_recorded_at

      t.timestamps
    end
  end
end
