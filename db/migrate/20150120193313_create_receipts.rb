class CreateReceipts < ActiveRecord::Migration
  def change
    create_table :receipts do |t|
      t.string :receipt

      t.timestamps
    end
  end
end
