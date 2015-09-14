class UpdateTagsCollationToUtf8mb4bin < ActiveRecord::Migration
  def change
    execute("ALTER TABLE tags MODIFY `name` varchar(191) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;")
  end
end
