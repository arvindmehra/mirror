class AddIndexBundleName < ActiveRecord::Migration
  def change
    add_index :products, :bundle_name_ios
    add_index :products, :bundle_name_android
    add_index :transactions, :bundle_name
  end
end
