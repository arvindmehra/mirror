class ChangeColumnActivityDate < ActiveRecord::Migration
  def change
  	 change_column :user_activities, :activity_date, :date
  end
end
