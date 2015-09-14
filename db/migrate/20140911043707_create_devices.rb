class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.belongs_to :user, index: true
      t.string :vendor_id
      t.string :platform

      t.timestamps
    end
  end
end
