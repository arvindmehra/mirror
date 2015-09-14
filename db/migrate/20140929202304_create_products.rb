class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :bundle_name_ios
      t.string :bundle_name_android
      t.string :name
      t.string :description

      t.timestamps
    end
  end
end
