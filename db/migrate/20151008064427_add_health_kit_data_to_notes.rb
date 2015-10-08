class AddHealthKitDataToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :heart_rate, :float
    add_column :notes, :sleep_time, :float
    add_column :notes, :temperature, :float
    add_column :notes, :whether_type, :string, :limit => 20
    add_column :notes, :steps_walked, :float
    add_column :notes, :calories_burnt, :float
  end
end
