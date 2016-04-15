class CreateFilterGroups < ActiveRecord::Migration
  def change
    create_table :filter_groups do |t|
    	t.string :name
    	t.string :expression
      t.timestamps
    end
  end
end
