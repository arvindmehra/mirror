class AddActivityGoalToUsers < ActiveRecord::Migration
  def change
    add_column :users, :activity_goal, :integer
  end
end
