class CreateFilters < ActiveRecord::Migration
  def change
    create_table :filters do |t|
      t.string :name
      t.string :family
      t.string :filter_type
      t.string :segment
      t.string :list_type
      t.string :operator
      t.string :condition
      t.datetime :start_date
      t.datetime :end_date

      t.timestamps
    end
  end
end
