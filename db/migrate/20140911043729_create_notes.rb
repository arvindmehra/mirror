class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.text :body
      t.belongs_to :location, index: true
      t.string :category

      t.timestamps
    end
  end
end
