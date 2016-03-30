class CreateDropDownLists < ActiveRecord::Migration
  def change
    create_table :drop_down_lists do |t|
      t.string :name
      t.string :value
      t.timestamps
    end
  end
end
