class AddFieldsToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :locale, :string
  end
end
