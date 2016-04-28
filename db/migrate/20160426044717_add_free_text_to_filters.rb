class AddFreeTextToFilters < ActiveRecord::Migration
  def change
    add_column :filters, :free_text, :text, after: :condition
  end
end
