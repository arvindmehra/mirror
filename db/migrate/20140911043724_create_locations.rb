class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.belongs_to :user, index: true
      t.string :address
      t.string :name
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
