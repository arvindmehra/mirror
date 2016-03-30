class CreateSuggestedHashtags < ActiveRecord::Migration
  def change
    create_table :suggested_hashtags do |t|
      t.string :language
      t.string :product
      t.string :hashtags
      t.string :exclusion_words

      t.timestamps
    end
  end
end
