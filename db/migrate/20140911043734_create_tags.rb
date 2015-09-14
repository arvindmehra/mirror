class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.belongs_to :note, index: true
      t.integer :index

      t.timestamps
    end
  end
end
